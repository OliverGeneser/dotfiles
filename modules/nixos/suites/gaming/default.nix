{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.suites.gaming;
in {
  options.suites.gaming = with types; {
    enable = mkBoolOpt false "Enable the gaming suite";
  };

  config = mkIf cfg.enable {
    hardware = {
      xpadneo.enable = true;
      xone.enable = true;

      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          mesa
          intel-media-driver # LIBVA_DRIVER_NAME=iHD
          intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
          libvdpau-va-gl
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [intel-vaapi-driver];
      };
    };

    environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Force intel-media-driver

    services.ratbagd.enable = true;

    programs = {
      gamemode.enable = true;
      gamescope.enable = true;
      steam = {
        enable = true;
        package = pkgs.steam.override {
          extraPkgs = p:
            with p; [
              mangohud
              gamemode
            ];
        };
        dedicatedServer.openFirewall = true;
        remotePlay.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      winetricks
      wineWowPackages.waylandFull
    ];
  };
}
