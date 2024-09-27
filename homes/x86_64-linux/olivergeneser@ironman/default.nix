{
  lib,
  inputs,
  pkgs,
  ...
}: {

  custom.user = {
    enable = true;
    name = "olivergeneser";
  };

  home.stateVersion = "23.11";
}
