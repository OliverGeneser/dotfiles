{
  lib,
  inputs,
  pkgs,
  ...
}: {
  roles = {
    desktop.enable = true;
    gaming.enable = true;
    office.enable = true;
    hobby.enable = true;
  };

  programs = {
    androidStudio.enable = true;
  };

  desktops.hyprland.enable = true;

  cli.programs.ssh.extraHosts = {
    "bitbucket-qinspect" = {
      hostname = "bitbucket.org";
      identityFile = "~/.ssh/ssh_prod_qreport";
      identitiesOnly = true;
    };
    "qmaster.q-inspect.com" = {
      hostname = "qmaster.q-inspect.com";
      identityFile = "~/.ssh/ssh_prod_qreport";
      identitiesOnly = true;
    };
    "q-inspect.dk" = {
      hostname = "q-inspect.dk";
      identityFile = "~/.ssh/ssh_prod_qreport";
      identitiesOnly = true;
    };
    "thor" = {
      hostname = "10.0.0.205";
      port = 1337;
      user = "nixos";
      identityFile = "~/.ssh/id_ecdsa_sk";
      identitiesOnly = true;
    };
  };

  custom.user = {
    enable = true;
    name = "olivergeneser";
  };

  home.stateVersion = "23.11";
}
