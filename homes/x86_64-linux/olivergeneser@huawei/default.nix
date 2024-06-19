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

  cli.programs.ssh.extraHosts = {
    "bitbucket-qinspect" = {
      hostname = "bitbucket.org";
      user = "git";
      identityFile = "~/.ssh/ssh_prod_qreport";
      identitiesOnly = true;
    };
  };

  custom.user = {
    enable = true;
    name = "olivergeneser";
  };

  home.stateVersion = "23.11";
}
