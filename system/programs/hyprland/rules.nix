{lib, ...}: {
  programs.hyprland.settings = {
    # layer rules
    layerrule = let
      toRegex = list: let
        elements = lib.concatStringsSep "|" list;
      in "^(${elements})$";

      lowopacity = [
        "bar"
        "calendar"
        "notifications"
        "system-menu"
      ];

      highopacity = [
        "anyrun"
        "osd"
        "logout_dialog"
      ];

      blurred = lib.concatLists [
        lowopacity
        highopacity
      ];
    in [
      "blur 1, match:namespace ${toRegex blurred}"
      "xray 1, match:namespace ${toRegex ["bar"]}"
      "ignore_alpha 0.5, match:namespace ${toRegex (highopacity ++ ["music"])}"
      "ignore_alpha 0.2, match:namespace ${toRegex lowopacity}"
    ];

    # window rules
    windowrule = [
      # telegram media viewer
      "float 1, match:title ^(Media viewer)$"

      # Bitwarden extension
      "float 1, match:title ^(.*Bitwarden Password Manager.*)$"

      # allow tearing in games
      "immediate 1, match:class ^(osu\!|cs2)$"

      # make Firefox/Zen PiP window floating and sticky
      "float 1, match:title ^(Picture-in-Picture)$"
      "pin 1, match:title ^(Picture-in-Picture)$"
      "fullscreen_state 0 *, match:title ^(Picture-in-Picture)$"
      "size 25% 25%, match:title ^(Picture-in-Picture)$"
      "move 100%-w-5 100%-w-5, match:title ^(Picture-in-Picture)$"

      # throw sharing indicators away
      "workspace special silent, match:title ^(Firefox — Sharing Indicator)$"
      "workspace special silent, match:title ^(Zen — Sharing Indicator)$"
      "workspace special silent, match:title ^(.*is sharing (your screen|a window)\.)$"

      # start Spotify and YouTube Music in ws9
      "workspace 9 silent, match:title ^(Spotify( Premium)?)$"
      "workspace 9 silent, match:title ^(YouTube Music)$"

      # idle inhibit while watching videos
      "idle_inhibit focus 1, match:class ^(mpv|.+exe|celluloid)$"
      "idle_inhibit focus 1, match:class ^(zen)$, match:title ^(.*YouTube.*)$"
      "idle_inhibit fullscreen 1, match:class ^(zen)$"

      "dim_around 1, match:class ^(gcr-prompter)$"
      "dim_around 1, match:class ^(xdg-desktop-portal-gtk)$"
      "dim_around 1, match:class ^(polkit-gnome-authentication-agent-1)$"
      "dim_around 1, match:class ^(zen)$, match:title ^(File Upload)$"

      # fix xwayland apps
      "rounding 0, match:xwayland 1"
      "center 1, match:class ^(.*jetbrains.*)$, match:title ^(Confirm Exit|Open Project|win424|win201|splash)$"
      "size 640 400, match:class ^(.*jetbrains.*)$, match:title ^(splash)$"

      # don't render hyprbars on tiling windows
      # "plugin:hyprbars:nobar, float 0"

      # less sensitive scroll for some windows
      # browser(-based)
      "scroll_touchpad 0.1, match:class ^(zen|helium|firefox|chromium-browser|chrome-.*)$"
      "scroll_touchpad 0.1, match:class ^(obsidian)$"
      "scroll_touchpad 0.1, match:class ^(steam)$"
      "scroll_touchpad 0.1, match:class ^(Zotero)$"
      # GTK3
      "scroll_touchpad 0.1, match:class ^(com.github.xournalpp.xournalpp)$"
      "scroll_touchpad 0.1, match:class ^(libreoffice.*)$"
      "scroll_touchpad 0.1, match:class ^(.virt-manager-wrapped)$"
      "scroll_touchpad 0.1, match:class ^(xdg-desktop-portal-gtk)$"
      # Qt5
      "scroll_touchpad 0.1, match:class ^(org.prismlauncher.PrismLauncher)$"
      "scroll_touchpad 0.1, match:class ^(org.kde.kdeconnect.app)$"
      # Others
      "scroll_touchpad 0.1, match:class ^(org.pwmt.zathura)$"

      # Steam
      "fullscreen 1, match:class ^steam_app_\d+$"
      "monitor 1, match:class ^steam_app_\d+$"
      "workspace 10, match:class ^steam_app_\d+$"

      # Satty
      "match:class ^(com.gabm.satty)$, fullscreen 1"

      # Android Studio Emulator
      "float 1, match:class ^(Emulator)$"
    ];
  };
}
