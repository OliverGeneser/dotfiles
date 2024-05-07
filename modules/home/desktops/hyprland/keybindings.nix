{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktops.hyprland;
  laptop_lid_switch = pkgs.writeShellScriptBin "laptop_lid_switch" ''
    #!/usr/bin/env bash

    if grep open /proc/acpi/button/lid/LID0/state; then
    		hyprctl keyword monitor "eDP-1, 2256x1504@60, 0x0, 1"
    else
    		if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
    				hyprctl keyword monitor "eDP-1, disable"
    		else
    				systemctl suspend
    		fi
    fi
  '';

  resize = pkgs.writeShellScriptBin "resize" ''
    #!/usr/bin/env bash

    # Initially inspired by https://github.com/exoess

    # Getting some information about the current window
    # windowinfo=$(hyprctl activewindow) removes the newlines and won't work with grep
    hyprctl activewindow > /tmp/windowinfo
    windowinfo=/tmp/windowinfo

    # Run slurp to get position and size
    if ! slurp=$(slurp); then
    		exit
    fi

    # Parse the output
    pos_x=$(echo $slurp | cut -d " " -f 1 | cut -d , -f 1)
    pos_y=$(echo $slurp | cut -d " " -f 1 | cut -d , -f 2)
    size_x=$(echo $slurp | cut -d " " -f 2 | cut -d x -f 1)
    size_y=$(echo $slurp | cut -d " " -f 2 | cut -d x -f 2)

    # Keep the aspect ratio intact for PiP
    if grep "title: Picture-in-Picture" $windowinfo; then
    		old_size=$(grep "size: " $windowinfo | cut -d " " -f 2)
    		old_size_x=$(echo $old_size | cut -d , -f 1)
    		old_size_y=$(echo $old_size | cut -d , -f 2)

    		size_x=$(((old_size_x * size_y + old_size_y / 2) / old_size_y))
    		echo $old_size_x $old_size_y $size_x $size_y
    fi

    # Resize and move the (now) floating window
    grep "fullscreen: 1" $windowinfo && hyprctl dispatch fullscreen
    grep "floating: 0" $windowinfo && hyprctl dispatch togglefloating
    hyprctl dispatch moveactive exact $pos_x $pos_y
    hyprctl dispatch resizeactive exact $size_x $size_y
  '';
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.keyBinds = {
      bind = {
        "SUPER, Return" = "exec, wezterm";
        "SUPER, E" = "exec, thunar";
        "SUPER, F" = "exec, ${config.desktops.addons.rofi.package}/bin/rofi -show drun -mode drun";
        "SUPER, Q" = "killactive,";
        "SUPER, X" = "Fullscreen,0";
        "SUPER, R" = "exec, ${resize}/bin/resize";
        "SUPER, Space" = "togglefloating,";
        "SUPER, V" = "exec, ${pkgs.pyprland}/bin/pypr toggle pavucontrol";
        "SUPER_SHIFT, T" = "exec, ${pkgs.pyprland}/bin/pypr toggle term";

        # Lock Screen
        ",XF86Launch5" = "exec,${pkgs.hyprlock}/bin/hyprlock";
        ",XF86Launch4" = "exec,${pkgs.hyprlock}/bin/hyprlock";
        "SUPER,backspace" = "exec,${pkgs.hyprlock}/bin/hyprlock";
        "SUPER,escape" = "exec,wlogout --column-spacing 50 --row-spacing 50";

        # Screenshot
        ",Print" = "exec,grimblast --notify copysave area";
        "SHIFT, Print" = "exec,grimblast --notify copy active";
        "CONTROL,Print" = "exec,grimblast --notify copy screen";
        "SUPER,Print" = "exec,grimblast --notify copy window";
        "ALT,Print" = "exec,grimblast --notify copy area";
        "SUPER,bracketleft" = "exec,grimblast --notify --cursor copysave area ~/Pictures/$(date \" + %Y-%m-%d \"T\"%H:%M:%S_no_watermark \").png";
        "SUPER,bracketright" = "exec, grimblast --notify --cursor copy area";

        # Focus
        "ALT,h" = "movefocus,l";
        "ALT,l" = "movefocus,r";
        "ALT,k" = "movefocus,u";
        "ALT,j" = "movefocus,d";
        "ALTCONTROL,h" = "focusmonitor,l";
        "ALTCONTROL,l" = "focusmonitor,r";
        "ALTCONTROL,k" = "focusmonitor,u";
        "ALTCONTROL,j" = "focusmonitor,d";

        # Change Workspace
        "ALT,1" = "workspace,1";
        "ALT,2" = "workspace,2";
        "ALT,3" = "workspace,3";
        "ALT,4" = "workspace,4";
        "ALT,5" = "workspace,5";
        "ALT,6" = "workspace,6";
        "ALT,7" = "workspace,7";
        "ALT,8" = "workspace,8";
        "ALT,9" = "workspace,9";
        "ALT,0" = "workspace,0";

        # Move Workspace
        "ALTSHIFT,1" = "movetoworkspacesilent,1";
        "ALTSHIFT,2" = "movetoworkspacesilent,2";
        "ALTSHIFT,3" = "movetoworkspacesilent,3";
        "ALTSHIFT,4" = "movetoworkspacesilent,4";
        "ALTSHIFT,5" = "movetoworkspacesilent,5";
        "ALTSHIFT,6" = "movetoworkspacesilent,6";
        "ALTSHIFT,7" = "movetoworkspacesilent,7";
        "ALTSHIFT,8" = "movetoworkspacesilent,8";
        "ALTSHIFT,9" = "movetoworkspacesilent,9";
        "ALTSHIFT,0" = "movetoworkspacesilent,0";
        "SUPERALT,h" = "movecurrentworkspacetomonitor,l";
        "SUPERALT,l" = "movecurrentworkspacetomonitor,r";
        "SUPERALT,k" = "movecurrentworkspacetomonitor,u";
        "SUPERALT,j" = "movecurrentworkspacetomonitor,d";
        "ALTSHIFT,L" = "movewindow,r";
        "ALTSHIFT,H" = "movewindow,l";
        "ALTSHIFT,K" = "movewindow,u";
        "ALTSHIFT,J" = "movewindow,d";

        # Swap windows
        "SUPERSHIFT,h" = "swapwindow,l";
        "SUPERSHIFT,l" = "swapwindow,r";
        "SUPERSHIFT,k" = "swapwindow,u";
        "SUPERSHIFT,j" = "swapwindow,d";

        # Scratch Pad
        "SUPER,u" = "togglespecialworkspace";
        "SUPERSHIFT,u" = "movetoworkspace,special";
      };
      bindi = {
        ",XF86MonBrightnessUp" = "exec, ${pkgs.brightnessctl}/bin/brightnessctl +5%";
        ",XF86MonBrightnessDown" = "exec, ${pkgs.brightnessctl}/bin/brightnessctl -5% ";
        ",XF86AudioRaiseVolume" = "exec, ${pkgs.pamixer}/bin/pamixer -i 5";
        ",XF86AudioLowerVolume" = "exec, ${pkgs.pamixer}/bin/pamixer -d 5";
        ",XF86AudioMute" = "exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute";
        ",XF86AudioMicMute" = "exec, ${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute";
        ",XF86AudioNext" = "exec,playerctl next";
        ",XF86AudioPrev" = "exec,playerctl previous";
        ",XF86AudioPlay" = "exec,playerctl play-pause";
        ",XF86AudioStop" = "exec,playerctl stop";
      };
      bindl = {
        ",switch:Lid Switch" = "exec, ${laptop_lid_switch}/bin/laptop_lid_switch";
      };
      bindm = {
        "SUPER, mouse:272" = "movewindow";
        "SUPER, mouse:273" = "resizewindow";
      };
    };
  };
}
