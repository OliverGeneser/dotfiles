{
  lib,
  inputs,
  pkgs,
  ...
}: {

  custom.user = {
    enable = true;
    name = "ironman";
  };

  home.stateVersion = "23.11";
}
