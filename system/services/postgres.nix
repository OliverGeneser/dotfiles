{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.custom.services.postgresql;
in
{
  options.custom.services.postgresql = {
    databases = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "local" ];
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
        ensureDatabases = [ "local" ] ++ cfg.databases;
        extensions = ps: with ps; [ vectorchord ];
        authentication = pkgs.lib.mkOverride 10 ''
          #...
          #type database DBuser origin-address auth-method
          local all       all     trust
        '';
        settings = {
          shared_preload_libraries = [ "vchord.so" ];
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
