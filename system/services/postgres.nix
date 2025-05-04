{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.custom.services.postgresql;
in {
  options.custom.services.postgresql = {
    databases = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["local"];
      description = "The databases to ensure is instatiated.";
    };
    backupLocation = mkOption {
      type = types.str;
      default = "/var/backup/postgresql";
      example = "/var/backup/postgresql";
      description = "The backup location for postgres.";
    };
  };

  config = {
    services = {
      postgresql = {
        enable = true;
        package = pkgs.postgresql_16_jit;
        ensureDatabases = ["local"] ++ cfg.databases;
        extensions = ps: with ps; [pgvecto-rs];
        authentication = pkgs.lib.mkOverride 10 ''
          #...
          #type database DBuser origin-address auth-method
          local all       all     trust
          # ipv4
          host  immich      immich     127.0.0.1/32   trust
          host  jellyseerr jellyseerr     127.0.0.1/32   trust
          # ipv6
          host immich       immich     ::1/128        trust
          host jellyseerr       jellyseerr     ::1/128        trust
        '';
        settings = {
          shared_preload_libraries = ["vectors.so"];
          search_path = "\"$user\", public, vectors";
        };
      };

      postgresqlBackup = {
        enable = true;
        location = cfg.backupLocation;
        backupAll = true;
        startAt = "*-*-* 10:00:00";
      };
    };
  };
}
