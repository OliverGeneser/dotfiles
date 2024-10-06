{ lib
, inputs
, pkgs
, ...
}: {
  roles = {
    desktop.enable = true;
    gaming.enable = true;
    office.enable = true;
    hobby.enable = true;
  };

  desktops.hyprland.enable = true;

  cli.programs.ssh.extraHosts = {
    "bitbucket-qinspect" = {
      hostname = "bitbucket.org";
      user = "git";
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
  };

  custom.user = {
    enable = true;
    name = "olivergeneser";
  };

  home.persistence."/persist/home/olivergeneser" = {
    directories = [
      "dotfiles"
      "work"
      "personal"
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      ".gnupg"
      ".ssh"
      ".nixops"
      ".local/share/keyrings"
      ".local/share/direnv"
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
    files = [
      ".screenrc"
    ];
    allowOther = true;
  };

  home.stateVersion = "23.11";
}
