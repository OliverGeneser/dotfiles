{
  lib,
  config,
  ...
}: {
  imports = [
    # editors
    ../../editors/nvim

    # programs
    ../../programs
    ../../programs/dev
    ../../programs/design/superslicer.nix
    ../../programs/design/freecad.nix
    ../../programs/design/gimp.nix
    ../../programs/games
    ../../programs/wayland

    # services
    # ../../services/cinny.nix

    # media services
    ../../services/media/playerctl.nix
    # ../../services/media/spotifyd.nix

    # system services
    ../../services/system/kdeconnect.nix
    ../../services/system/polkit-agent.nix
    ../../services/system/syncthing.nix
    # ../../services/system/tailray.nix
    ../../services/system/udiskie.nix

    # wayland-specific
    ../../services/wayland/gammastep.nix
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix
    # ../../services/wayland/wluma.nix

    # terminal emulators
    ../../terminal/emulators/foot.nix
    ../../terminal/emulators/wezterm
  ];

  config = {
    home = {
      username = "olivergeneser";
      homeDirectory = "/home/olivergeneser";
      stateVersion = "23.11";
      extraOutputsToInstall = ["doc" "devdoc"];
    };

    services.syncthing.settings = {
      devices = {
        "apollo" = {
          id = "YX2IAXK-3MDJKKG-O6NXVKH-V2RBIZX-5M4I73R-R65A6B6-QHX7OUU-ETH7EQB";
        };
      };

      folders = {
        # Name of folder in Syncthing, also the folder ID
        "dev" = {
          id = "rrk9d-szxeq";
          path = "~/dev"; # Which folder to add to Syncthing
          devices = ["apollo"]; # Which devices to share the folder with
          type = "sendonly";
        };
      };
    };

    terminal.programs.ssh.extraHosts = {
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
        port = 22;
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
        port = 22;
        user = "nixos";
        identityFile = "~/.ssh/id_ecdsa_sk";
        identitiesOnly = true;
      };
    };

    wayland.windowManager.hyprland.settings = {
      monitor = [
        "Unknown-1, disable"
        "DP-5, preferred, auto, 1, bitdepth, 10"
      ];

      input = {
        kb_layout = lib.mkForce "us,dk";
        kb_variant = "altgr-intl,";
        kb_options = "grp:alt_space_toggle,";
      };
    };
  };
}
