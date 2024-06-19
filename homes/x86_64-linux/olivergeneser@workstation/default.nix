{
  lib,
  inputs,
  pkgs,
  ...
}: {
  suites = {
    desktop.enable = true;
    gaming.enable = true;
    office.enable = true;
  };

  desktops.hyprland.enable = true;

  custom.user = {
    enable = true;
    name = "olivergeneser";
  };

  home.stateVersion = "23.11";
}
