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
      services = [
        {
          "Media" = [
            {
              "Jellyfin" = {
                icon = "jellyfin.png";
                href = "http://10.0.0.205:8096";
                description = "";
                widget = {
                  type = "jellyfin";
                  url = "http://localhost:8096";
                  key = "{{HOMEPAGE_VAR_JELLYFIN}}";
                  enableBlocks = true; # optional, defaults to false
                  enableNowPlaying = true; # optional, defaults to true
                  enableUser = true; # optional, defaults to false
                  showEpisodeNumber = true; # optional, defaults to false
                  expandOneStreamToTwoRows = false; # optional, defaults to true
                };
              };
            }
            {
              "Jellyseerr" = {
                icon = "jellyseerr.png";
                href = "http://10.0.0.205:8095";
                description = "";
                widget = {
                  type = "jellyseerr";
                  url = "http://localhost:8095";
                  key = "{{HOMEPAGE_VAR_JELLYSEERR}}";
                };
              };
            }
            {
              "Sonarr" = {
                icon = "sonarr.png";
                href = "http://10.0.0.205:8989";
                description = "";
              };
            }
            {
              "Radarr" = {
                icon = "radarr.png";
                href = "http://10.0.0.205:7878";
                description = "";
              };
            }
          ];
        }
        {
          "Services" = [
            {
              "Immich" = {
                icon = "immich.png";
                href = "http://10.0.0.205:2283";
                description = "";
                widget = {
                  type = "immich";
                  url = "http://localhost:2283";
                  key = "{{HOMEPAGE_VAR_IMMICH}}";
                  version = 2;
                };
              };
            }
          ];
        }
      ];
      settings = {
        title = "Homelab Dashboard";
        favicon = "https://geneser.dev/favicon.ico";
        headerStyle = "clean";
        layout = [
          {
            Media = {
              header = true;
              style = "column";
            };
          }
          {
            Services = {
              header = true;
              style = "column";
            };
          }
        ];
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
            label = "System";
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
            label = "Storage";
            expanded = true;
            disk = [
              "/mnt/disk1"
              "/mnt/disk2"
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
  };
}
