{
  inputs,
  pkgs,
  ...
}: let
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
  '';

  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  workspaces = builtins.concatLists (builtins.genList (
      x: let
        ws = let
          c = (x + 1) / 10;
        in
          builtins.toString (x + 1 - (c * 10));
      in [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    )
    10);

  toggle = program: let
    prog = builtins.substring 0 14 program;
  in "pkill ${prog} || uwsm app -- ${program}";

  runOnce = program: "pgrep ${program} || uwsm app -- ${program}";
in {
  programs.hyprland.settings = {
    # mouse movements
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];

    # binds
    bind =
      [
        # compositor commands
        "$mod SHIFT, E, exec, pkill Hyprland"
        "$mod, E, exec, uwsm app -- pcmanfm"
        "$mod, F, exec, ${toggle "tofi-drun"} | xargs hyprctl dispatch exec --"
        "$mod, Q, killactive,"
        "$mod, X, fullscreen, 1"
        "$mod, G, togglegroup,"
        "$mod SHIFT, N, changegroupactive, f"
        "$mod SHIFT, P, changegroupactive, b"
        "$mod, R, togglesplit,"
        "$mod ALT, R, exec, ${resize}/bin/resize"
        "$mod, T, togglefloating,"
        "$mod ALT, , resizeactive,"
        "$mod, Z, exec, ${pkgs.pyprland}/bin/pypr zoom ++0.5"
        "$mod SHIFT, Z, exec, ${pkgs.pyprland}/bin/pypr zoom"
        "$mod, V, exec, ${pkgs.pyprland}/bin/pypr toggle pwvucontrol"

        # utility
        # terminal
        "$mod, Return, exec, uwsm app -- ${inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ghostty"
        # logout menu
        "$mod, Escape, exec, ${toggle "wlogout"} -b 4 -p layer-shell"
        # lock screen
        "$mod, L, exec, loginctl lock-session"
        # lock screen, to be used with the special key Fn+F10 on my keyboard
        "$mod, I, exec, loginctl lock-session"
        # Suspend/Hibernate system
        "$mod, S, exec, systemctl suspend"
        # select area to perform OCR on
        "$mod, O, exec, ${runOnce "wl-ocr"}"
        ", XF86Favorites, exec, ${runOnce "wl-ocr"}"
        # open calculator
        ", XF86Calculator, exec, ${toggle "qalculate-qt"}"

        # move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "ALT, h, movefocus, l"
        "ALT, l, movefocus, r"
        "ALT, k, movefocus, u"
        "ALT, j, movefocus, d"

        # Change Workspace
        "ALT, 1, focusworkspaceoncurrentmonitor, 1"
        "ALT, 2, focusworkspaceoncurrentmonitor, 2"
        "ALT, 3, focusworkspaceoncurrentmonitor, 3"
        "ALT, 4, focusworkspaceoncurrentmonitor, 4"
        "ALT, 5, focusworkspaceoncurrentmonitor, 5"
        "ALT, 6, focusworkspaceoncurrentmonitor, 6"
        "ALT, 7, focusworkspaceoncurrentmonitor, 7"
        "ALT, 8, focusworkspaceoncurrentmonitor, 8"
        "ALT, 9, focusworkspaceoncurrentmonitor, 9"
        "ALT, 0, focusworkspaceoncurrentmonitor, 10"

        # Move Workspace
        "ALTSHIFT, 1, movetoworkspacesilent, 1"
        "ALTSHIFT, 2, movetoworkspacesilent, 2"
        "ALTSHIFT, 3, movetoworkspacesilent, 3"
        "ALTSHIFT, 4, movetoworkspacesilent, 4"
        "ALTSHIFT, 5, movetoworkspacesilent, 5"
        "ALTSHIFT, 6, movetoworkspacesilent, 6"
        "ALTSHIFT, 7, movetoworkspacesilent, 7"
        "ALTSHIFT, 8, movetoworkspacesilent, 8"
        "ALTSHIFT, 9, movetoworkspacesilent, 9"
        "ALTSHIFT, 0, movetoworkspacesilent, 10"

        # screenshot
        # area
        ", Print, exec, ${runOnce "grimblast"} --notify copysave area"
        "$mod SHIFT, R, exec, ${runOnce "grimblast"} --notify copysave area"
        "$mod, P, exec, ${runOnce "grimblast"} --notify copysave area"

        # current screen
        "CTRL, Print, exec, ${runOnce "grimblast"} --notify --cursor copysave output"
        "$mod SHIFT CTRL, R, exec, ${runOnce "grimblast"} --notify --cursor copysave output"

        # all screens
        "ALT, Print, exec, ${runOnce "grimblast"} --notify --cursor copysave screen"
        "$mod SHIFT ALT, R, exec, ${runOnce "grimblast"} --notify --cursor copysave screen"

        # special workspace
        "$mod SHIFT, grave, movetoworkspace, special"
        "$mod, grave, togglespecialworkspace, eDP-1"

        # cycle workspaces
        "$mod, bracketleft, workspace, m-1"
        "$mod, bracketright, workspace, m+1"

        # cycle monitors
        "$mod SHIFT, bracketleft, focusmonitor, l"
        "$mod SHIFT, bracketright, focusmonitor, r"

        # send focused workspace to left/right monitors
        "$mod SHIFT ALT, bracketleft, movecurrentworkspacetomonitor, l"
        "$mod SHIFT ALT, bracketright, movecurrentworkspacetomonitor, r"
      ]
      ++ workspaces;

    bindr = [
      # launcher
      # "$mod, SUPER_L, exec, ${toggle "tofi-drun"}"
    ];

    bindl = [
      # media controls
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioStop, exec, playerctl stop"

      # volume
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

      # ",switch:Lid Switch, exec, ${runOnce "hypridle"}"
    ];

    bindle = [
      # volume
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

      # backlight
      ", XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5"
      ", XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5"
    ];
  };
}
