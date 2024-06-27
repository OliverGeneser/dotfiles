{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktops.addons.kanshi;

  mkOutput = name: args: {
    inherit name;
    config =
      {
        criteria = name;
        status = "enable";
        mode = null;
        position = null;
        scale = 1.0;
        transform = "normal";
      }
      // args;
  };

  internalMonitor = mkOutput "eDP-1" {};
  externalMonitor = mkOutput "HDMI-A-1" {};
  dockedMonitor = mkOutput "DP-1" {};
in {
  options.desktops.addons.kanshi = {
    enable = mkEnableOption "Enable kanshi display addon";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kanshi
    ];

    wayland.windowManager.hyprland.config.workspace = let
      mapWsBind = wss: mon: map (ws: "${toString ws}, monitor:${mon}") wss;
    in
      lib.concatLists [
        # assign odd numbered workspaces to internal monitor
        (mapWsBind [1 2 3 4 5 6 7 8 9] internalMonitor.name)
        # assign evens to the external monitor
        #(mapWsBind [ 10 ] dockedMonitor.name)
        #(mapWsBind [ 11 ] externalMonitor.name)
      ];

    services.kanshi = let
      moveWorkspace = ws: mon: "${hyprctl} dispatch moveworkspacetomonitor '${toString ws}' '${mon}'";
      moveWorkspaces = wss: mon: map (ws: moveWorkspace ws mon) wss;
    in {
      enable = true;
      package = pkgs.kanshi;
      systemdTarget = "hyprland-session.target";

      settings = [
        {
          profile.name = "undocked";
          profile.outputs = [
            (internalMonitor.config // {scale = 1.333333;})
          ];
        }
        {
          profile.name = "docked";
          profile.outputs = [
            (internalMonitor.config // {scale = 1.333333;})
            (dockedMonitor.config // {})
          ];
        }
        {
          profile.name = "desktop";
          profile.outputs = [
            {
              criteria = "DP-1";
              position = "0,0";
              mode = "2560x1440@165Hz";
            }
            {
              criteria = "HDMI-A-1";
              position = "-1920,180";
              mode = "1920x1080@60Hz";
            }
            {
              criteria = "DVI-D-1";
              position = "320,-1080";
              mode = "1920x1080@60Hz";
            }
          ];
        }
      ];
    };
  };
}
