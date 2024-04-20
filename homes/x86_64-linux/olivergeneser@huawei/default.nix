{
  lib,
  inputs,
  pkgs,
  ...
}: {
  suites = {
    desktop.enable = true;
    gaming.enable = true;
  };

  desktops.hyprland.enable = true;

  programs.waybar.package = inputs.waybar.packages."${pkgs.system}".waybar;
  wayland.windowManager.hyprland.keyBinds.bindi = lib.mkForce {};

  custom.user = {
    enable = true;
    name = "olivergeneser";
  };

  home.stateVersion = "23.11";
}
