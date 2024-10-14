{ config
, lib
, pkgs
, ...
}:
with lib;
with lib.custom; let
  cfg = config.desktops.addons.hyprpaper;

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
in
{
  options.desktops.addons.hyprpaper = with types; {
    enable = mkBoolOpt false "Whether to enable the hyprpaper config";
  };

  config = mkIf cfg.enable {
    home.packages = [ wallpaperRandomizer ];

    services.hyprpaper = {
      enable = true;

      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;
      };
      #settings = {
      #  preload = [
      #    "${pkgs.custom.wallpapers.Kurzgesagt-Galaxy_2}"
      #  ];
      #  wallpaper = [ ", ${pkgs.custom.wallpapers.Kurzgesagt-Galaxy_2}" ];
      #};
    };

    systemd.user = {
      services.wallpaperRandomizer = {
        Install = { WantedBy = [ "graphical-session.target" ]; };

        Unit = {
          Description = "Set random desktop background using hyprpaper";
          After = [ "graphical-session-pre.target" "hyprpaper.service" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = "${wallpaperRandomizer}/bin/wallpaperRandomizer";
          IOSchedulingClass = "idle";
        };
      };

      timers.wallpaperRandomizer = {
        Unit = { Description = "Set random desktop background using hyprpaper on an interval"; };

        Timer = { OnUnitActiveSec = "1h"; };

        Install = { WantedBy = [ "timers.target" ]; };
      };
    };
  };
}
