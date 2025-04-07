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

  desktops.hyprland = {
    enable = true;
    extra_monitors = ["DP-5,preferred,auto,1,bitdepth,10"];
    extra_monitors_workspace = ["0, monitor:HDMI-A-2"];
  };

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
    "ironman" = {
      hostname = "10.0.0.210";
      port = 22000;
      user = "oliverg";
      identityFile = "~/.ssh/id_ecdsa_sk";
      identitiesOnly = false;
    };
    "tunnelboy" = {
      hostname = "10.0.0.230";
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
