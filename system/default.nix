let
  server = [
    ./core
    ./core/boot.nix
    ./core/server.nix

    ./hardware/fwupd.nix
    ./hardware/vaapi.nix

    ./network
    ./network/avahi.nix
    ./network/tailscale.nix

    ./programs/home-manager.nix

    ./services
    ./services/homepage.nix
    ./services/immich.nix
    ./services/jellyfin.nix
    ./services/openssh.nix
    ./services/pipewire.nix
    ./services/signal-reporting-bot.nix
    ./services/virtualisation/podman
    ./services/virtualisation/gluetun
  ];

  desktop-minimal = [
    ./core
    ./core/boot.nix

    ./hardware/fwupd.nix
    ./hardware/logitech.nix

    ./network
    ./network/avahi.nix
    ./network/tailscale.nix

    ./programs

    ./services
    ./services/openssh.nix
    ./services/greetd.nix
    ./services/pipewire.nix
    ./services/printing.nix
    ./services/searx.nix
    ./services/virtualisation/podman
  ];
  desktop =
    desktop-minimal
    ++ [
      ./hardware/graphics.nix
    ];

  desktop-nvidia =
    desktop-minimal
    ++ [
      ./hardware/nvidia.nix
    ];

  laptop =
    desktop
    ++ [
      ./hardware/bluetooth.nix

      ./services/backlight.nix
      ./services/power.nix
    ];
in {
  inherit desktop desktop-nvidia laptop server;
}
