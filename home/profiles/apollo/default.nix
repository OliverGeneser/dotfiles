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
    ../../programs/design/superslicer.nix
    ../../programs/design/freecad.nix
    ../../programs/design/gimp.nix
    ../../programs/games
    ../../programs/wayland

    # services
    # ../../services/quickshell
    # ../../services/cinny.nix

    # media services
    ../../services/media/playerctl.nix
    # ../../services/media/spotifyd.nix

    # system services
    ../../services/system/kdeconnect.nix
    ../../services/system/polkit-agent.nix
    ../../services/system/power-monitor.nix
    ../../services/system/syncthing.nix
    ../../services/system/tailray.nix
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

    wayland.windowManager.hyprland.settings = let
      # Generated using https://gist.github.com/fufexan/e6bcccb7787116b8f9c31160fc8bc543
      accelpoints = "0.5 0.000 0.053 0.115 0.189 0.280 0.391 0.525 0.687 0.880 1.108 1.375 1.684 2.040 2.446 2.905 3.422 4.000 4.643 5.355 6.139";
    in {
      monitor = [
        # "DP-1, preferred, auto-left, auto"
        # "DP-2, preferred, auto-left, auto"
        "eDP-1, preferred, auto, 1.600000"
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
