{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    kanshi
  ];

  services.kanshi = {
    enable = true;
    package = pkgs.kanshi;
    systemdTarget = "graphical-session.target";
  };
}
