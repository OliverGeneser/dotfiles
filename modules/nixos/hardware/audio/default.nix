{ config
, pkgs
, lib
, ...
}:
with lib;
with lib.custom; let
  cfg = config.hardware.audio;
in
{
  options.hardware.audio = with types; {
    enable = mkBoolOpt false "Enable or disable pipewire";
  };

  config = mkIf cfg.enable {
    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    programs.noisetorch.enable = true;

    systemd.user = {
      services.noisetorchAutostart = {
        enable = true;
        wantedBy = [ "default.target" ];
        description = "Auto Start Noisetorch Service";
        requires = [ "sys-devices-pci0000:00-0000:00:14.0-usb3-3\\x2d1-3\\x2d1:1.0-sound-card2-controlC2.device" ];
        after = [ "pipewire.service" "sys-devices-pci0000:00-0000:00:14.0-usb3-3\\x2d1-3\\xd21:1.0-sound-card2-controlC2.device" ];

        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i -s alsa_input.usb-Solid_State_System_Co._Ltd._DRELANMIC_010000000000-00.mono-fallback -t 95";
          ExecStop = "${pkgs.noisetorch}/bin/noisetorch -u";
          RemainAfterExit = "yes";
          Restart = "on-failure";
          RestartSec = "3";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      pulsemixer
    ];
  };
}
