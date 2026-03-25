{
  self,
  inputs,
  config,
  lib,
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
    #../../programs/design/freecad.nix
    ../../programs/design/gimp.nix
    ../../programs/games
    ../../programs/wayland

    # services
    # ../../services/cinny.nix

    # media services
    ../../services/media/playerctl.nix
    # ../../services/media/spotifyd.nix

    # system services
    ../../services/system/syncthing.nix
    ../../services/system/tailray.nix
    ../../services/system/udiskie.nix

    ../../services/vpn/eduvpn.nix

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
    ../../terminal/programs/k9s.nix
    ../../terminal/programs/nix.nix
    ../../terminal/programs/nodejs.nix
    ../../terminal/programs/opencode.nix
    ../../terminal/programs/podman.nix
    ../../terminal/programs/skim.nix
    ../../terminal/programs/sqlite.nix
    ../../terminal/programs/ssh.nix
    ../../terminal/programs/temporal.nix
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
        "enterprise" = {
          id = "4NW7R3L-2MNRG2Q-AZFFT2P-33FI6L3-T3FYW3P-S3GE3MR-PLI3OKP-CJTAFQ5";
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
          devices = ["enterprise"]; # Which devices to share the folder with
          type = "receiveonly";
        };
      };
    };

    terminal.programs.ssh = {
      withGSSAPI = true;
      extraHosts = {
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
          hostname = "thor";
          port = 22;
          user = "nixos";
          identityFile = "~/.ssh/id_ecdsa_sk";
          identitiesOnly = true;
        };
        "enterprise" = {
          hostname = "10.0.0.200";
          port = 22;
          user = "olivergeneser";
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
        "aiadm" = {
          hostname = "aiadm.cern.ch";
          user = "ogeneser";
          kexAlgorithms = [
            "curve25519-sha256"
            "curve25519-sha256@libssh.org"
            "ecdh-sha2-nistp256"
            "ecdh-sha2-nistp384"
            "ecdh-sha2-nistp521"
            "diffie-hellman-group-exchange-sha256"
            "diffie-hellman-group14-sha256"
            "diffie-hellman-group16-sha512"
            "diffie-hellman-group18-sha512"
          ];
        };
        "zenodo-*" = {
          hostname = "%h.cern.ch";
          user = "root";
          kexAlgorithms = [
            "curve25519-sha256"
            "curve25519-sha256@libssh.org"
            "ecdh-sha2-nistp256"
            "ecdh-sha2-nistp384"
            "ecdh-sha2-nistp521"
            "diffie-hellman-group-exchange-sha256"
            "diffie-hellman-group14-sha256"
            "diffie-hellman-group16-sha512"
            "diffie-hellman-group18-sha512"
          ];

          extraOptions = {
            GSSAPIAuthentication = "yes";
            GSSAPIDelegateCredentials = "yes";
            SetEnv = "TERM=xterm-256color";
          };
        };

        "zenodo-ops" = {
          hostname = "%h.cern.ch";
          extraOptions = {
            RequestTTY = "yes";
            RemoteCommand = "tmux new-session -A -s oliver";
          };
        };
      };
    };

    services.kanshi.settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = null;
            position = null;
            scale = 1.0;
            transform = "normal";
          }
        ];
      }
      {
        profile.name = "docked-work-oliver";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = null;
            scale = 1.0;
            transform = "normal";
            position = "3440,0";
          }
          {
            criteria = "Dell Inc. DELL P3425WE 6S0SY54";
            status = "enable";
            mode = "3440x1440@99.98Hz";
            scale = 1.0;
            transform = "normal";
            position = "0,0";
          }
        ];
      }
    ];

    wayland.windowManager.hyprland.settings = let
      # Generated using https://gist.github.com/fufexan/e6bcccb7787116b8f9c31160fc8bc543
      accelpoints = "0.5 0.000 0.053 0.115 0.189 0.280 0.391 0.525 0.687 0.880 1.108 1.375 1.684 2.040 2.446 2.905 3.422 4.000 4.643 5.355 6.139";
    in {
      monitor = [
        ", preferred, auto, auto"
        # "DP-1, preferred, auto-left, auto"
        # "DP-2, preferred, auto-left, auto"
      ];

      input = {
        kb_layout = lib.mkForce "dk,us";
        kb_variant = ",altgr-intl";
        kb_options = ",grp:alt_space_toggle";
      };

      device = {
        name = "elan2841:00-04f3:31eb-touchpad";
        accel_profile = "custom ${accelpoints}";
        scroll_points = accelpoints;
        natural_scroll = true;
      };
    };
  };
}
