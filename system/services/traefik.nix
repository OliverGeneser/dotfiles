{
  config,
  lib,
  ...
}:
let
  # Public DNS (Cloudflare) points *.thor.geneser.dev at thor's Tailscale IP,
  # so these subdomains resolve for everyone but are only reachable from inside
  # the tailnet. Traefik terminates TLS with a real Let's Encrypt certificate.
  domain = "thor.geneser.dev";

  # <name>.thor.geneser.dev -> 127.0.0.1:<port>
  proxiedServices = {
    jellyfin = 8096;
    immich = 2283;
    git = 4500;
    homepage = 8173;
    syncthing = 8384;
    radarr = 7878;
    sonarr = 8989;
    prowlarr = 9696;
    seerr = 8095;
    qbittorrent = 8090;
  };

  # One wildcard Let's Encrypt certificate (*.thor.geneser.dev + the bare
  # domain as SAN), issued and renewed automatically via the Cloudflare
  # DNS-01 challenge. Unlike the previous HTTP-01 setup, thor does not need
  # to be reachable from the public internet at all.
  wildcardTls = {
    certResolver = "letsencrypt";
    domains = [
      {
        main = "*.${domain}";
        sans = [ domain ];
      }
    ];
  };
in
{
  sops.secrets.traefik_env = {
    # Contains: CF_DNS_API_TOKEN=<token with Zone:DNS:Edit on geneser.dev>
    sopsFile = ./secrets.yaml;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.traefik = {
    enable = true;

    # Cloudflare API token for the DNS-01 challenge
    environmentFiles = [ config.sops.secrets.traefik_env.path ];

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure.address = ":443";
      };

      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      certificatesResolvers.letsencrypt.acme = {
        email = "postmaster@geneser.dev";
        storage = "${config.services.traefik.dataDir}/acme.json";
        # DNS-01 instead of HTTP-01: no public exposure needed, and it is
        # the only challenge type that supports wildcard certificates.
        dnsChallenge = {
          provider = "cloudflare";
          resolvers = [ "1.1.1.1:53" ];
        };
      };

      api.dashboard = true;
    };

    dynamicConfigOptions = {
      http.routers =
        (lib.mapAttrs (name: _port: {
          entryPoints = [ "websecure" ];
          rule = "Host(`${name}.${domain}`)";
          service = name;
          tls = wildcardTls;
        }) proxiedServices)
        // {
          # Traefik dashboard at traefik.thor.geneser.dev (tailnet-only)
          traefik-dashboard = {
            entryPoints = [ "websecure" ];
            rule = "Host(`traefik.${domain}`)";
            service = "api@internal";
            tls = wildcardTls;
          };
          # Bare thor.geneser.dev -> homepage dashboard
          root = {
            entryPoints = [ "websecure" ];
            rule = "Host(`${domain}`)";
            service = "homepage";
            tls = wildcardTls;
          };
        };

      http.services = lib.mapAttrs (name: port: {
        loadBalancer.servers = [
          {
            url = "http://127.0.0.1:${toString port}";
          }
        ];
      }) proxiedServices;
    };
  };
}
