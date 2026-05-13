{
  config,
  self,
  pkgs,
  ...
}:
let
  smartd-notification2telegram =
    pkgs.resholve.writeScript "smartd-notification2telegram.sh"
      {
        interpreter = "${pkgs.bash}/bin/bash";
        inputs = [
          pkgs.curl
          pkgs.coreutils
          pkgs.gawk
          pkgs.gnugrep
          pkgs.gnused
          pkgs.jq
          pkgs.smartmontools
        ];
      }
      ''
        escape_markdown_v2() {
          printf "%s" "$1" | sed -E 's/[][()\\_*\\~`>#+=\\|{}!\\.\\-]/\\\\&/g'
        }

        # Echo environment variables into a temp file
        #echo "Variables are":
        #echo "$SMARTD_DEVICE"
        #echo "$SMARTD_DEVICESTRING"
        #echo "$SMARTD_DEVICETYPE"
        #echo "$SMARTD_MESSAGE"
        #echo "$SMARTD_FULLMESSAGE"
        #echo "$SMARTD_ADDRESS"
        #echo "$SMARTD_SUBJECT"
        #echo "$SMARTD_TFIRST"
        #echo "$SMARTD_TFIRSTEPOCH"

        DEVICE=$SMARTD_DEVICE

        MESSAGE="$SMARTD_TFIRST\n"
        MESSAGE+="Host: $HOSTNAME\n"
        MESSAGE+="Device: $DEVICE\n"
        MESSAGE+="Drive: $SMARTD_DEVICEINFO\n\n"
        MESSAGE+="--- SMART Status ---\n"

        MESSAGE+="\n** $SMARTD_MESSAGE **\n"

        RAW=$(smartctl -i -a -j -d $SMARTD_DEVICETYPE $DEVICE)
        STATUS=$(smartctl -H $DEVICE)
        POWER_ON_TIME=$(echo "$RAW" | jq '.power_on_time.hours')
        SMART_ATTRIBUTES=""

        if [[ "$DEVICE" == /dev/sd* ]]; then
          SMART_ATTRIBUTES=$(echo "$RAW" | jq -r '.ata_smart_attributes.table[] | select(.id == 5 or .id == 194 or .id == 196 or .id == 197 or .id == 198) | "\(.name): \(.raw.string)"' )
        elif [[ "$DEVICE" == /dev/nvme* ]]; then
          SMART_ATTRIBUTES=$(echo "$RAW" | jq -r '.nvme_smart_health_information_log | {critical_warning, temperature, available_spare, percentage_used, media_errors, num_err_log_entries} | to_entries | .[] | "\(.key): \(.value)"' )
        else
          SMART_ATTRIBUTES="$DEVICE can't find SMART attributes."
        fi

        MESSAGE+="$(printf "\nTotal Power on Time: %s\n%s\n%s" \
            "$POWER_ON_TIME" \
            "$(echo "$STATUS" | sed '1,4d')" \
            "$SMART_ATTRIBUTES" \
            )\n"

        MESSAGE+="$SMARTD_MESSAGE"
        echo $MESSAGE

        #\"parse_mode\": \"MarkdownV2\"
        # Send message
        curl -H "Content-Type: application/json" \
          -d "{\"chat_id\": \"$(cat ${
            config.sops.secrets."smartd_chat_id".path
          })\", \"text\": \"$MESSAGE\", \"disable_notification\": true }" \
          "https://api.telegram.org/bot$(cat ${config.sops.secrets."smartd_bot_token".path})/sendMessage"
      '';
in
{
  sops.secrets = {
    smartd_chat_id = {
      sopsFile = ./secrets.yaml;
      owner = config.custom.user.name;
    };
    smartd_bot_token = {
      sopsFile = ./secrets.yaml;
      owner = config.custom.user.name;
    };
  };

  services.smartd = {
    enable = true;
    autodetect = false;
    devices = [
      {
        device = "/dev/sda";
        #"-s L/../../7/02"
        options = "-s (S/../.././02|L/../../6/03) -a -o on -S on -m <nomailer> -M exec ${smartd-notification2telegram}";
      }
      {
        device = "/dev/sdb";
        options = "-s (S/../.././02|L/../../6/03) -a -o on -S on -m <nomailer> -M exec ${smartd-notification2telegram}";
      }
      {
        device = "/dev/sdc";
        options = "-s (S/../.././02|L/../../6/03) -a -o on -S on -m <nomailer> -M exec ${smartd-notification2telegram}";
      }
      {
        device = "/dev/nvme0";
        options = "-s (S/../.././02|L/../../6/03) -a -o on -S on -m <nomailer> -M exec ${smartd-notification2telegram}";
      }
    ];
  };
}
