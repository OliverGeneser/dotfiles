{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.custom.signal-reporting-bot;

  smartShortReporting = pkgs.writeShellScriptBin "smartShortReporting" ''
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script requires root privileges. Please run with sudo."
        exit 1
    fi

    DISKS=$(${pkgs.util-linux}/bin/lsblk -n -d -o NAME | ${pkgs.gawk}/bin/awk '/^sd/ || /^nvme[0-9]/ {sub(/n[0-9]+$/, "", $1); print "/dev/" $1}')
    MESSAGE="Short SMART Test\n"

    for disk in $DISKS; do
        echo -e "Running SMART test on $disk..."
        ${pkgs.smartmontools}/bin/smartctl -t short $disk
        echo -e "\n\n"
        sleep 2
    done

    for disk in $DISKS; do
        while true; do
            TEST_STATUS="1"

            if [[ "$disk" == /dev/sd* ]]; then
                echo "$disk is an SATA/SAS disk (/dev/sd*). Status: $TEST_STATUS"
                if ${pkgs.smartmontools}/bin/smartctl -a $disk | grep -q "Self-test routine in progress"; then
                    TEST_STATUS="1"
                else
                    TEST_STATUS="0"
                fi
            elif [[ "$disk" == /dev/nvme* ]]; then
                TEST_STATUS="$(${pkgs.smartmontools}/bin/smartctl -aj $disk | ${pkgs.jq}/bin/jq '.nvme_self_test_log.current_self_test_operation.value')"
                echo "$disk is an NVMe disk (/dev/nvme*). Status: $TEST_STATUS"
            else
                echo "$disk is not a recognized disk type."
                break
            fi

            if [ $TEST_STATUS == "0" ]; then
                break  # Exit the loop if the test is finished
            fi

            echo "Test on $disk not done yet waiting 15 sec more"

            sleep 15
        done

        echo "SMART test done on $disk..."

        RAW=$(${pkgs.smartmontools}/bin/smartctl -i -a -j $disk)
        STATUS=$(${pkgs.smartmontools}/bin/smartctl -H $disk)
        POWER_ON_TIME=$(echo "$RAW" | ${pkgs.jq}/bin/jq '.power_on_time.hours')
        SMART_ATTRIBUTES=""

        if [[ "$disk" == /dev/sd* ]]; then
            SMART_ATTRIBUTES=$(echo "$RAW" | ${pkgs.jq}/bin/jq -r '.ata_smart_attributes.table[] | select(.id == 5 or .id == 196 or .id == 197 or .id == 198) | "\(.name): \(.raw.value)"' )
        elif [[ "$disk" == /dev/nvme* ]]; then
            SMART_ATTRIBUTES=$(echo "$RAW" | ${pkgs.jq}/bin/jq -r '.nvme_smart_health_information_log | {critical_warning, available_spare, percentage_used, media_errors, num_err_log_entries} | to_entries | .[] | "\(.key): \(.value)"' )
        else
            SMART_ATTRIBUTES="$disk can't find SMART attributes."
        fi

        MESSAGE="$MESSAGE$(printf "\nSMART Status %s:\nTotal Power on Time: %s\n%s\nSMART Stats:\n%s" \
        "$disk" \
        "$POWER_ON_TIME" \
        "$(echo "$STATUS" | sed '1,4d')" \
        "$SMART_ATTRIBUTES" \
        )\n"
    done

    echo -e "$MESSAGE" | ${pkgs.signal-cli}/bin/signal-cli send -g "TO+DykH3guaqDHrFpJzM1QUQzSAfqBsEIgwVKrP74rQ=" --message-from-stdin
  '';
in {
  options.services.custom.signal-reporting-bot = with types; {
    enable = mkBoolOpt false "Whether to enable the Signal status reporting";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      smartShortReporting
      pkgs.smartmontools
      pkgs.signal-cli
    ];

    systemd = {
      services."signal-report-short-smart-bot" = {
        description = "Send S.M.A.R.T status and zfs status in signal chat";
        script = "${smartShortReporting}/bin/smartShortReporting";

        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };

      timers."signal-report-short-smart-bot" = {
        description = "Run short S.M.A.R.T reports every night";
        timerConfig = {
          OnCalendar = "daily"; #"Mon *-*-* 03:00:00";
        };
        wantedBy = ["timers.target"];
      };
    };
  };
}
