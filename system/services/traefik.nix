{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
    8080
  ];

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };

        websecure = {
          address = ":443";
          asDefault = true;
          http.tls.certResolver = "letsencrypt";
        };
      };

      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      certificatesResolvers.letsencrypt.acme = {
        email = "postmaster@geneser.dev";
        storage = "${config.services.traefik.dataDir}/acme.json";
        httpChallenge.entryPoint = "web";
      };

      api.dashboard = true;
      # Access the Traefik dashboard on <Traefik IP>:8080 of your server
      # api.insecure = true;
    };

    dynamic.dir = "${config.services.traefik.dataDir}/config";

    dynamicConfigOptions = {
      http.routers = {
        jellyfin = {
          entryPoints = [ "websecure" ];
          rule = "Host(`jellyfin.geneser.dev`)";
          service = "jellyfin";
          tls.certResolver = "letsencrypt";
        };
        immich = {
          entryPoints = [ "websecure" ];
          rule = "Host(`immich.geneser.dev`)";
          service = "immich";
          tls.certResolver = "letsencrypt";
        };
      };
      http.services = {
        jellyfin.loadBalancer.servers = [
          {
            url = "http://thor:8096";
          }
        ];
        immich.loadBalancer.servers = [
          {
            url = "http://thor:2283";
          }
        ];
      };
    };
  };
}
