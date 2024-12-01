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

  home.persistence."/persist/home/nixos" = {
    directories = [
      "dotfiles"
      ".gnupg"
      ".ssh"
      ".nixops"
      ".local/share/keyrings"
      ".local/share/direnv"
    ];
    files = [];
    allowOther = true;
  };

  home.stateVersion = "23.11";
}
