{
  lib,
  inputs,
  pkgs,
  ...
}: {
  #cli.programs.ssh.extraHosts = {
  #  "qmaster.q-inspect.com" = {
  #    hostname = "qmaster.q-inspect.com";
  #    identityFile = "~/.ssh/ssh_prod_qreport";
  #    identitiesOnly = true;
  #  };
  #  "q-inspect.dk" = {
  #    hostname = "q-inspect.dk";
  #    identityFile = "~/.ssh/ssh_prod_qreport";
  #    identitiesOnly = true;
  #  };
  #};

  roles = {
    server.enable = true;
  };

  custom.user = {
    enable = true;
    name = "nixos";
  };

  home.stateVersion = "23.11";
}
