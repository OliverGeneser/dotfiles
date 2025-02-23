{
  lib,
  inputs,
  pkgs,
  ...
}: {
  cli.programs.ssh.extraHosts = {
    "ironman" = {
      hostname = "10.0.0.210";
      port = 22000;
      user = "oliverg";
    };
  };

  roles = {
    server.enable = true;
  };

  custom.user = {
    enable = true;
    name = "nixos";
  };

  home.stateVersion = "23.11";
}
