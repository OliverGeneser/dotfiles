{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.custom.homepage;
in {
  options.services.custom.homepage = {
    enable = mkEnableOption "Enable homepage for homelab services";
  };

  config = mkIf cfg.enable {
    sops.secrets.homepage_env = {
      sopsFile = ../secrets.yaml;
    };

    services = {
      homepage-dashboard = {
        enable = true;
        environmentFile = config.sops.secrets.homepage_env.path;
        listenPort = 8173;
        bookmarks = [];
        services = [
          {
            external = [
              {
                Tandoor = {
                  icon = "tandoor.png";
                  href = "{{HOMEPAGE_VAR_TANDOOR_URL}}";
                  description = "recipe management";
                  widget = {
                    type = "tandoor";
                    url = "{{HOMEPAGE_VAR_TANDOOR_INTERNAL_URL}}";
                    key = "{{HOMEPAGE_VAR_TANDOOR_API_KEY}}";
                  };
                };
              }
              {
                Jellyfin = {
                  icon = "jellyfin.png";
                  href = "{{HOMEPAGE_VAR_JELLYFIN_URL}}";
                  description = "media management";
                  widget = {
                    type = "jellyfin";
                    url = "{{HOMEPAGE_VAR_JELLYFIN_INTERNAL_URL}}";
                    key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
                  };
                };
              }
              {
                Jellyseerr = {
                  icon = "jellyseerr.png";
                  href = "{{HOMEPAGE_VAR_JELLYSEERR_URL}}";
                  description = "request management";
                  widget = {
                    type = "jellyseerr";
                    url = "{{HOMEPAGE_VAR_JELLYSEERR_INTERNAL_URL}}";
                    key = "{{HOMEPAGE_VAR_JELLYSEERR_API_KEY}}";
                  };
                };
              }
              {
                Authentik = {
                  icon = "authentik.png";
                  href = "{{HOMEPAGE_VAR_AUTHENTIK_URL}}";
                  description = "auth management";
                  widget = {
                    type = "authentik";
                    url = "{{HOMEPAGE_VAR_AUTHENTIK_INTERNAL_URL}}";
                    key = "{{HOMEPAGE_VAR_AUTHENTIK_API_KEY}}";
                  };
                };
              }
            ];
          }
          {
            internal = [
              {
                Syncthing = {
                  icon = "syncthing.png";
                  href = "{{HOMEPAGE_VAR_HOME_SYNCTHING_URL}}";
                  description = "file syncing";
                  widget = {
                    type = "strelaysrv";
                    url = "{{HOMEPAGE_VAR_SYNCTHING_INTERNAL_URL}}";
                  };
                };
              }
              {
                Gitea = {
                  icon = "gitea.png";
                  href = "{{HOMEPAGE_VAR_GITEA_URL}}";
                  description = "git server";
                  widget = {
                    type = "gitea";
                    url = "{{HOMEPAGE_VAR_GITEA_INTERNAL_URL}}";
                    key = "{{HOMEPAGE_VAR_GITEA_API_KEY}}";
                  };
                };
              }
              {
                Immich = {
                  icon = "immich.png";
                  href = "{{HOMEPAGE_VAR_IMMICH_URL}}";
                  description = "photo management";
                  widget = {
                    type = "immich";
                    url = "{{HOMEPAGE_VAR_IMMICH_INTERNAL_URL}}";
                    key = "{{HOMEPAGE_VAR_IMMICH_API_KEY}}";
                  };
                };
              }
            ];
          }
          {
            monitoring = [
              {
                Traefik = {
                  icon = "traefik.png";
                  href = "{{HOMEPAGE_VAR_TRAEFIK_URL}}";
                  description = "reverse proxy";
                  widget = {
                    type = "traefik";
                    url = "{{HOMEPAGE_VAR_TRAEFIK_INTERNAL_URL}}";
                  };
                };
              }
            ];
          }
          {
            media = [
              {
                Jellyfin = {
                  icon = "jellyfin.png";
                  href = "{{HOMEPAGE_VAR_JELLYFIN_URL}}";
                  description = "media management";
                  widget = {
                    type = "jellyfin";
                    url = "{{HOMEPAGE_VAR_JELLYFIN_INTERNAL_URL}}";
                    key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
                  };
                };
              }
              {
                Radarr = {
                  icon = "radarr.png";
                  href = "{{HOMEPAGE_VAR_RADARR_URL}}";
                  description = "film management";
                  widget = {
                    type = "radarr";
                    url = "{{HOMEPAGE_VAR_RADARR_INTERNAL_URL}}";
                    key = "{{HOMEPAGE_VAR_RADARR_API_KEY}}";
                  };
                };
              }
              {
                Sonarr = {
                  icon = "sonarr.png";
                  href = "{{HOMEPAGE_VAR_SONARR_URL}}";
                  description = "tv management";
                  widget = {
                    type = "sonarr";
                    url = "{{HOMEPAGE_VAR_SONARR_INTERNAL_URL}}";
                    key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
                  };
                };
              }
              {
                Lidarr = {
                  icon = "lidarr.png";
                  href = "{{HOMEPAGE_VAR_LIDARR_URL}}";
                  description = "music management";
                  widget = {
                    type = "lidarr";
                    url = "{{HOMEPAGE_VAR_LIDARR_INTERNAL_URL}}";
                    key = "{{HOMEPAGE_VAR_LIDARR_API_KEY}}";
                  };
                };
              }
              {
                Readarr = {
                  icon = "readarr.png";
                  href = "{{HOMEPAGE_VAR_READARR_URL}}";
                  description = "book management";
                  widget = {
                    type = "readarr";
                    url = "{{HOMEPAGE_VAR_READARR_INTERNAL_URL}}";
                    key = "{{HOMEPAGE_VAR_READARR_API_KEY}}";
                  };
                };
              }
              {
                Prowlarr = {
                  icon = "prowlarr.png";
                  href = "{{HOMEPAGE_VAR_PROWLARR_URL}}";
                  description = "index management";
                  widget = {
                    type = "prowlarr";
                    url = "{{HOMEPAGE_VAR_PROWLARR_INTERNAL_URL}}";
                    key = "{{HOMEPAGE_VAR_PROWLARR_API_KEY}}";
                  };
                };
              }
              {
                Bazarr = {
                  icon = "bazarr.png";
                  href = "{{HOMEPAGE_VAR_BAZARR_URL}}";
                  description = "subtitles management";
                  widget = {
                    type = "bazarr";
                    url = "{{HOMEPAGE_VAR_BAZARR_INTERNAL_URL}}";
                    key = "{{HOMEPAGE_VAR_BAZARR_API_KEY}}";
                  };
                };
              }
              {
                Qbittorrent = {
                  icon = "qbittorent.png";
                  href = "{{HOMEPAGE_VAR_QBITTORRENT_URL}}";
                  description = "torrent client";
                  widget = {
                    type = "qbittorrent";
                    url = "{{HOMEPAGE_VAR_QBITTORRENT_INTERNAL_URL}}";
                    username = "{{HOMEPAGE_VAR_QBITTORRENT_USERNAME}}";
                    password = "{{HOMEPAGE_VAR_QBITTORRENT_PASSWORD}}";
                  };
                };
              }
            ];
          }
          {
            network = [
              {
                PiHole = {
                  icon = "pihole.png";
                  href = "{{HOMEPAGE_VAR_PIHOLE_URL}}";
                  description = "dns block";
                  widget = {
                    type = "pihole";
                    url = "{{HOMEPAGE_VAR_PIHOLE_INTERNAL_URL}}";
                    version = 6;
                    key = "{{HOMEPAGE_VAR_PIHOLE_KEY}}";
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
          layout = {
            external = {
              style = "row";
              columns = 3;
            };
            internal = {
              style = "row";
              columns = 3;
            };
            media = {
              style = "row";
              columns = 3;
            };
            network = {
              style = "row";
              columns = 2;
            };
            monitoring = {
              style = "row";
              columns = 2;
            };
            disk = {
              style = "row";
              columns = 2;
            };
          };
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
  };
}
