{ pkgs
, config
, lib
, ...
}:
with lib; let
  cfg = config.roles.desktop;
in
{
  options.roles.desktop = {
    enable = mkEnableOption "Enable desktop suite";
  };

  config = mkIf cfg.enable {
    roles = {
      common.enable = true;
      development.enable = true;
    };

    services = { };
    browsers = {
      mullvad.enable = true;
      firefox.enable = true;
      chromium.enable = true;
    };
    desktops.addons.xdg.enable = true;

    programs = {
      shotwell.enable = true;
      webcord.enable = true;
      bitwarden.enable = true;
      audio = {
        audacity.enable = true;
      };
      email = {
        tuta.enable = true;
      };
      media = {
        vlc.enable = true;
        jellyfin.enable = true;
      };
      design = {
        gimp.enable = true;
      };
      meld.enable = true;
    };

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
      LIBSEAT_BACKEND = "logind";
    };

    # TODO: move this to somewhere
    home.packages = with pkgs; [
      mplayer
      mtpfs
      jmtpfs
      brightnessctl
      xdg-utils
      wl-clipboard
      clipse
      pamixer
      playerctl
      xfce.thunar

      grimblast
      slurp
      sway-contrib.grimshot
      pkgs.satty
    ];
  };
}
