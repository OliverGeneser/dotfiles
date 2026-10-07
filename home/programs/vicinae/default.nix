{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.vicinae.homeManagerModules.default ];

  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true; # default: false
      autoStart = true; # default: true (if systemd.enable is true)
      environment = {
        USE_LAYER_SHELL = 1;
        # Bundled Qt can't init EGL/GLES2 on this host (QRhiGles2 context
        # creation fails -> abort on toggle). Force Qt Quick software
        # rendering; verified window opens as layer-shell surface.
        QT_QUICK_BACKEND = "software";
      };
    };

    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      # bluetooth
      nix
      power-profile
      wifi-commander
    ];
  };
}
