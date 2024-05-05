{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktops.addons.kanshi;
in {
  options.desktops.addons.kanshi = {
    enable = mkEnableOption "Enable kanshi display addon";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kanshi
    ];

    services.kanshi = {
      enable = true;
      package = pkgs.kanshi;
      systemdTarget = "";
      profiles = {
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              scale = 1.0;
              status = "enable";
            }
          ];
        };

        desktop = {
          outputs = [
            {
              criteria = "ASUSTek COMPUTER INC VG27A N8LMQS070105";
              position = "0,0";
              mode = "2560x1440@144Hz";
            }
            {
              criteria = "AOC 2778G5 F67G8BA000681";
              position = "-1920,180";
              mode = "1920x1080@60Hz";
            }
            {
              criteria = "AOC 2460 D04E9BA001708";
              position = "320,-1080";
              mode = "1920x1080@60Hz";
            }
          ];
        };
        home_office_alt = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "DP-5";
              position = "3840,0";
              mode = "3840x2160@143.85600Hz";
            }
            {
              criteria = "DP-4";
              position = "0,0";
              mode = "3840x2160@60Hz";
            }
          ];
        };
      };
    };
  };
}
