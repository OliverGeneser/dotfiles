{
  config,
  lib,
  ...
}: {
  sops.secrets.homepage_env = {
    sopsFile = ./secrets.yaml;
  };

  services = {
    homepage-dashboard = {
      enable = true;
      environmentFile = config.sops.secrets.homepage_env.path;
      listenPort = 8173;
      bookmarks = [];
      services = [];
      settings = {
        title = "Homelab Dashboard";
        favicon = "https://geneser.dev/favicon.ico";
        headerStyle = "clean";
      };
      widgets = [
        {
          search = {
            provider = "duckduckgo";
            target = "_blank";
            showSearchSuggestions = true; # Optional
          };
        }
        {
          resources = {
            label = "system";
            cpu = true;
            cputemp = true;
            uptime = true;
            memory = true;
            disk = [
              "/"
            ];
          };
        }
        {
          resources = {
            label = "storage";
            expanded = true;
            disk = [
              "/mnt/root/disk1"
              "/mnt/root/disk2"
              "/mnt/parity1"
            ];
          };
        }
        {
          openmeteo = {
            label = "Copenhagen";
            timezone = "Europe/Copenhagen";
            latitude = "{{HOMEPAGE_VAR_LATITUDE_0}}";
            longitude = "{{HOMEPAGE_VAR_LONGITUDE_0}}";
            units = "metric";
          };
        }
        {
          openmeteo = {
            label = "Vordingborg";
            timezone = "Europe/Copenhagen";
            latitude = "{{HOMEPAGE_VAR_LATITUDE_1}}";
            longitude = "{{HOMEPAGE_VAR_LONGITUDE_1}}";
            units = "metric";
          };
        }
      ];
    };

    traefik = {
      dynamicConfigOptions = {
        http = {
          services.homepage.loadBalancer.servers = [
            {
              url = "http://localhost:8173";
            }
          ];

          routers = {
            homepage = {
              entryPoints = ["websecure"];
              rule = "Host(`homepage.lab.geneser.dev`)";
              service = "homepage";
              tls.certResolver = "letsencrypt";
              middlewares = ["authentik"];
            };
          };
        };
      };
    };
  };
}
