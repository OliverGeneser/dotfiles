{
  pkgs,
  inputs,
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.suites.desktop.addons.hyprland;
in {
  options.suites.desktop.addons.hyprland = with types; {
    enable = mkBoolOpt false "Enable or disable the hyprland window manager.";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      # set the flake package
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    suites.desktop.addons.greetd.enable = true;
    suites.desktop.addons.xdg-portal.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
