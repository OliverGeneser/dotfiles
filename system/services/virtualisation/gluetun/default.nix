{
  self,
  config,
  pkgs,
  lib,
  ...
}: {
  # Runtime
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      # Required for container networking to be able to use names.
      dns_enabled = true;
    };
  };

  sops.secrets = {
    gluetun_env = {
      sopsFile = ../../secrets.yaml;
    };
    qbittorrent_env = {
      sopsFile = ../../secrets.yaml;
    };
    jellyseerr_env = {
      sopsFile = ../../secrets.yaml;
    };
    radarr_env = {
      sopsFile = ../../secrets.yaml;
    };
    sonarr_env = {
      sopsFile = ../../secrets.yaml;
    };
    prowlarr_env = {
      sopsFile = ../../secrets.yaml;
    };
  };

  # Enable container name DNS for non-default Podman networks.
  # https://github.com/NixOS/nixpkgs/issues/226365
  networking.firewall.interfaces."podman*" = {
    allowedTCPPorts = [6881 7878 8888 8388 8090 8095 8989 9696];
    allowedUDPPorts = [53 5353 6881 8388 8989 9696];
  };

  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."gluetun" = {
    image = "qmcgaw/gluetun:latest";
    environmentFiles = [config.sops.secrets.gluetun_env.path];
    volumes = [
      "/persist/docker-volumes/gluetun:/gluetun:rw"
    ];
    ports = [
      "6881:6881"
      "7878:7878/tcp"
      "8090:8090/tcp"
      "8095:8095/tcp"
      "8388:8388"
      "8888:8888/tcp"
      "8989:8989"
      "9696:9696"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--device=/dev/net/tun:/dev/net/tun:rwm"
      "--network-alias=gluetun"
      "--network=gluetun_default"
      "--security-opt=no-new-privileges:true"
    ];
  };

  systemd.services."podman-gluetun" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-gluetun_default.service"
    ];
    requires = [
      "podman-network-gluetun_default.service"
    ];
    partOf = [
      "podman-compose-gluetun-root.target"
    ];
    wantedBy = [
      "podman-compose-gluetun-root.target"
    ];
  };

  virtualisation.oci-containers.containers."qbittorrent" = {
    image = "linuxserver/qbittorrent:latest";
    environmentFiles = [config.sops.secrets.qbittorrent_env.path];
    volumes = [
      "/persist/torrents:/data/torrents:rw"
      "/mnt/storage/media:/data/media:rw"
      "/persist/docker-volumes/qbittorrent:/config:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
      "--security-opt=no-new-privileges:true"
    ];
  };

  systemd.services."podman-qbittorrent" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-gluetun-root.target"
    ];
    wantedBy = [
      "podman-compose-gluetun-root.target"
    ];
  };

  virtualisation.oci-containers.containers."jellyseerr" = {
    image = "fallenbagel/jellyseerr:latest";
    environmentFiles = [config.sops.secrets.jellyseerr_env.path];
    volumes = [
      "/persist/docker-volumes/jellyseerr:/app/config:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
      "--security-opt=no-new-privileges:true"
    ];
  };

  systemd.services."podman-jellyseerr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-gluetun-root.target"
    ];
    wantedBy = [
      "podman-compose-gluetun-root.target"
    ];
  };

  virtualisation.oci-containers.containers."radarr" = {
    image = "ghcr.io/hotio/radarr:latest";
    environmentFiles = [config.sops.secrets.radarr_env.path];
    volumes = [
      "/persist/etc/localtime:/etc/localtime:ro"
      "/persist/docker-volumes/radarr:/config:rw"
      "/persist/torrents:/data/torrents:rw"
      "/mnt/storage/media:/data/media:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
      "--security-opt=no-new-privileges:true"
    ];
  };

  systemd.services."podman-radarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-gluetun-root.target"
    ];
    wantedBy = [
      "podman-compose-gluetun-root.target"
    ];
  };

  virtualisation.oci-containers.containers."sonarr" = {
    image = "ghcr.io/hotio/sonarr:latest";
    environmentFiles = [config.sops.secrets.sonarr_env.path];
    volumes = [
      "/persist/etc/localtime:/etc/localtime:ro"
      "/persist/docker-volumes/sonarr:/config:rw"
      "/persist/torrents:/data/torrents:rw"
      "/mnt/storage/media:/data/media:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
      "--security-opt=no-new-privileges:true"
    ];
  };

  systemd.services."podman-sonarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-gluetun-root.target"
    ];
    wantedBy = [
      "podman-compose-gluetun-root.target"
    ];
  };

  virtualisation.oci-containers.containers."prowlarr" = {
    image = "ghcr.io/hotio/prowlarr:latest";
    environmentFiles = [config.sops.secrets.prowlarr_env.path];
    volumes = [
      "/persist/etc/localtime:/etc/localtime:ro"
      "/persist/docker-volumes/prowlarr:/config:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
      "--security-opt=no-new-privileges:true"
    ];
  };

  systemd.services."podman-prowlarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-gluetun-root.target"
    ];
    wantedBy = [
      "podman-compose-gluetun-root.target"
    ];
  };

  # Networks
  systemd.services."podman-network-gluetun_default" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f gluetun_default";
    };
    script = ''
      podman network inspect gluetun_default || podman network create gluetun_default
    '';
    partOf = ["podman-compose-gluetun-root.target"];
    wantedBy = ["podman-compose-gluetun-root.target"];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-gluetun-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = ["multi-user.target"];
  };
}
