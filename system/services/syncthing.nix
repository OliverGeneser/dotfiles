{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.custom.services.syncthing;
in {
  options.custom.services.syncthing = {
    devices = mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            default = name;
            description = "The name of the device";
          };
          id = lib.mkOption {
            type = lib.types.str;
            description = "The device ID.";
          };
        };
      }));
    };

    folders = mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            default = name;
            description = "The name of the folder";
          };
          id = lib.mkOption {
            type = lib.types.str;
            description = "The id of the folder.";
          };
          path = lib.mkOption {
            type = lib.types.str;
            description = "The path to the folder.";
          };
          devices = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "A list of device IDs to sync with.";
          };
          ignorePerms = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to ignore file permissions during syncing.";
          };
          type = lib.mkOption {
            type = lib.types.enum [
              "sendreceive"
              "sendonly"
              "receiveonly"
              "receiveencrypted"
            ];
            default = "sendreceive";
            description = ''
              Controls how the folder is handled by Syncthing.
              See <https://docs.syncthing.net/users/config.html#config-option-folder.type>.
            '';
          };
        };
      }));
    };
  };

  config = {
    services = {
      syncthing = {
        enable = true;
        group = "users";
        overrideDevices = true; # overrides any devices added or deleted through the WebUI
        overrideFolders = true; # overrides any folders added or deleted through the WebUI
        settings = {
          devices = cfg.devices;
          folders = cfg.folders;
        };
      };
    };
  };
}
