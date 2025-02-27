{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.styles.stylix;

  wallpapers = "(${pkgs.custom.wallpapers.gfda_34-black_5120x2880} ${pkgs.custom.wallpapers.gfda_40-black_5120x2880} ${pkgs.custom.wallpapers.gfda_45-black_5120x2880} ${pkgs.custom.wallpapers.gfda_63-black_5120x2880} ${pkgs.custom.wallpapers.gfda_72-black_5120x2880} ${pkgs.custom.wallpapers.gfda_91-black_5120x2880} ${pkgs.custom.wallpapers.gfda_155-black_5120x2880} ${pkgs.custom.wallpapers.gfda_162-black_5120x2880} ${pkgs.custom.wallpapers.gfda_172-black_5120x2880} ${pkgs.custom.wallpapers.gfda_189-black_5120x2880} ${pkgs.custom.wallpapers.gfda_192-black_5120x2880} ${pkgs.custom.wallpapers.gfda_203-black_5120x2880} ${pkgs.custom.wallpapers.gfda_205-black_5120x2880} ${pkgs.custom.wallpapers.gfda_207-black_5120x2880} ${pkgs.custom.wallpapers.gfda_208-black_5120x2880} ${pkgs.custom.wallpapers.gfda_210-black_5120x2880} ${pkgs.custom.wallpapers.gfda_212-black_5120x2880} ${pkgs.custom.wallpapers.gfda_215-black_5120x2880} ${pkgs.custom.wallpapers.gfda_230-black_5120x2880} ${pkgs.custom.wallpapers.gfda_242-black_5120x2880})";

  wallpaperRandomizer = pkgs.writeShellScriptBin "wallpaperRandomizer" ''
    wallpapers=${wallpapers}
    rand=$[$RANDOM % ''${#wallpapers[@]}]
    wallpaper=''${wallpapers[$rand]}

    monitor=(`hyprctl monitors | grep Monitor | awk '{print $2}'`)
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $wallpaper
    for m in ''${monitor[@]}; do
      hyprctl hyprpaper wallpaper "$m,contain:$wallpaper"
    done
  '';
in {
  options.styles.stylix = {
    enable = lib.mkEnableOption "Enable stylix";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [wallpaperRandomizer];

    fonts = {
      enableDefaultPackages = false;
      fontconfig.enable = true;
      fontDir.enable = true;

      fontconfig = {
        localConf = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>
              <alias binding="weak">
                  <family>monospace</family>
                  <prefer>
                      <family>emoji</family>
                  </prefer>
              </alias>
              <alias binding="weak">
                  <family>sans-serif</family>
                  <prefer>
                      <family>emoji</family>
                  </prefer>
              </alias>
              <alias binding="weak">
                  <family>serif</family>
                  <prefer>
                      <family>emoji</family>
                  </prefer>
              </alias>
          </fontconfig>
        '';
      };
    };

    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      homeManagerIntegration.autoImport = false;
      homeManagerIntegration.followSystem = false;

      image = pkgs.custom.wallpapers.gfda_40-black_5120x2880;

      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
      };

      fonts = {
        sizes = {
          terminal = 14;
          applications = 12;
          popups = 12;
        };

        serif = {
          name = "Source Serif";
          package = pkgs.source-serif;
        };

        sansSerif = {
          name = "Noto Sans";
          package = pkgs.noto-fonts;
        };

        monospace = {
          package = pkgs.custom.monolisa;
          name = "MonoLisa Nerd Font";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

    systemd = {
      services.wallpaperRandomizer = {
        wantedBy = ["graphical-session.target"];

        description = "Set random desktop background using hyprpaper";
        after = ["graphical-session-pre.target" "hyprpaper.service"];
        partOf = ["graphical-session.target"];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${wallpaperRandomizer}/bin/wallpaperRandomizer";
          IOSchedulingClass = "idle";
        };
      };

      timers.wallpaperRandomizer = {
        description = "Set random desktop background using hyprpaper on an interval";
        timerConfig = {
          OnUnitActiveSec = "1h";
        };
        wantedBy = ["timers.target"];
      };
    };
  };
}
