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
    ./services/gitea.nix
    ./services/gitea-mirror.nix
    ./services/homepage.nix
    ./services/immich.nix
    ./services/jellyfin.nix
    ./services/openssh.nix
    ./services/pipewire.nix
    ./services/signal-reporting-bot.nix
    ./services/smartd.nix
    # ./services/traefik.nix
    ./services/virtualisation/podman
    ./services/virtualisation/gluetun
  ];

  desktop = [
    ./core
    ./core/boot.nix

    ./hardware/bluetooth.nix
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
    # ./services/searx.nix
    # ./services/virtualisation/docker
    ./services/virtualisation/podman
    ./services/yubikey.nix
  ];

  laptop = desktop ++ [
    ./hardware/bluetooth.nix

    ./services/backlight.nix
    ./services/power.nix
  ];
in
{
  inherit desktop laptop server;
}
