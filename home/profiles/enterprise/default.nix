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
    ../../programs/design/inkscape.nix
    ../../programs/design/orca-slicer.nix
    ../../programs/design/superslicer.nix
    ../../programs/design/freecad.nix
    ../../programs/design/gimp.nix
    ../../programs/games
    ../../programs/wayland

    # services
    # ../../services/cinny.nix
    # ../../services/easyeffects.nix

    # media services
    ../../services/media/playerctl.nix
    # ../../services/media/spotifyd.nix

    # system services
    ../../services/system/syncthing.nix
    ../../services/system/tailray.nix
    ../../services/system/udiskie.nix

    # wayland-specific
    ../../services/wayland/gammastep.nix
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix
    # ../../services/wayland/wluma.nix

    # terminal
    ../../terminal/programs/aws.nix
    ../../terminal/programs/bat.nix
    ../../terminal/programs/bun.nix
    ../../terminal/programs/cli.nix
    ../../terminal/programs/ffmpeg.nix
    ../../terminal/programs/git.nix
    ../../terminal/programs/htop.nix
    ../../terminal/programs/nix.nix
    ../../terminal/programs/nodejs.nix
    ../../terminal/programs/opencode.nix
    ../../terminal/programs/python.nix
    ../../terminal/programs/podman.nix
    ../../terminal/programs/skim.nix
    ../../terminal/programs/sqlite.nix
    ../../terminal/programs/ssh.nix
    ../../terminal/programs/turso.nix
    ../../terminal/programs/yazi
    ../../terminal/programs/xdg.nix

    # terminal emulators
    ../../terminal/emulators/ghostty.nix

    # terminal multiplexers
    ../../terminal/multiplexer/tmux.nix
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
        "ariane" = {
          id = "J23DJJ5-XXGSCKX-SRHBGRL-YOAGKNI-324SCVQ-MKRRANP-QDOYVWS-L3XWAQR";
        };
        "thor" = {
          id = "PXNEEIO-OUUPKQ7-RJZ2UTW-UOBCO4L-2F73KMA-GZVIOGK-ASSV74C-RYUN7QE";
        };
      };

      folders = {
        # Name of folder in Syncthing, also the folder ID
        "dev" = {
          id = "rrk9d-szxeq";
          path = "~/dev"; # Which folder to add to Syncthing
          devices = ["apollo" "ariane" "thor"]; # Which devices to share the folder with
          type = "sendonly";
        };
      };
    };

    terminal.programs.ssh.extraHosts = {
      "bitbucket-qinspect" = {
        hostname = "bitbucket.org";
        identityFile = "~/.ssh/id_q_inspect_prod_0";
        identitiesOnly = true;
        kexAlgorithms = [
          "sntrup761x25519-sha512"
          "sntrup761x25519-sha512@openssh.com"
          "mlkem768x25519-sha256"
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
        ];
      };
      "qmaster.q-inspect.com" = {
        hostname = "qmaster.q-inspect.com";
        identityFile = "~/.ssh/id_q_inspect_prod_0";
        identitiesOnly = true;
        kexAlgorithms = [
          "sntrup761x25519-sha512"
          "sntrup761x25519-sha512@openssh.com"
          "mlkem768x25519-sha256"
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
        ];
      };
      "q-inspect.dk" = {
        hostname = "q-inspect.dk";
        identityFile = "~/.ssh/id_q_inspect_prod_0";
        identitiesOnly = true;
        kexAlgorithms = [
          "sntrup761x25519-sha512"
          "sntrup761x25519-sha512@openssh.com"
          "mlkem768x25519-sha256"
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
        ];
      };
      "thor" = {
        hostname = "thor";
        port = 22;
        user = "nixos";
        identityFile = "~/.ssh/id_ecdsa_sk";
        identitiesOnly = true;
      };
      "ironman" = {
        hostname = "ironman";
        port = 22000;
        user = "oliverg";
        identityFile = "~/.ssh/id_ecdsa_sk";
        identitiesOnly = false;
        kexAlgorithms = [
          "sntrup761x25519-sha512"
          "sntrup761x25519-sha512@openssh.com"
          "mlkem768x25519-sha256"
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
        ];
      };
      "tunnelboy" = {
        hostname = "10.0.0.230";
        port = 22;
        user = "nixos";
        identityFile = "~/.ssh/id_ecdsa_sk";
        identitiesOnly = true;
      };
      "melina" = {
        hostname = "linux354.unoeuro.com";
        port = 22;
        user = "melina-workout.dk";
        identityFile = "~/.ssh/ssh_prod_qreport";
        identitiesOnly = true;
      };
    };

    services.kanshi.settings = [
      {
        profile.name = "desktop";
        profile.outputs = [
          {
            criteria = "DP-2";
            position = "0,0";
            scale = 1.0;
            mode = "2560x1440@144Hz";
          }
          {
            criteria = "HDMI-A-1";
            position = "320,-1080";
            scale = 1.0;
            mode = "1920x1080@60Hz";
          }
        ];
      }
      {
        profile.name = "desktop-fix";
        profile.outputs = [
          {
            criteria = "DP-5";
            position = "0,0";
            scale = 1.0;
            mode = "2560x1440@144Hz";
          }
          {
            criteria = "HDMI-A-2";
            position = "320,-1080";
            scale = 1.0;
            mode = "1920x1080@60Hz";
          }
        ];
      }
    ];

    wayland.windowManager.hyprland.settings = {
      monitor = [
        ", preferred, auto, auto"
        "DP-5, preferred, auto, auto, bitdepth, 10"
      ];

      input = {
        kb_layout = lib.mkForce "us,dk";
        kb_variant = "altgr-intl,";
        kb_options = "grp:alt_space_toggle,";
      };
    };
  };
}
