{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.system.services.syncthing;
in {
  options.system.services.syncthing = {
    devices = mkOption {
      type = lib.types.attrsOf (
        lib.types.attrs {
          id = lib.mkOption {
            type = lib.types.str;
            description = "The device ID.";
          };
        }
      );
      default = {};
      description = "A map of device names to device configurations.";
      example = {
        "device2" = {id = "DEVICE-ID-GOES-HERE";};
      };
    };
    folders = mkOption {
      type = lib.types.attrsOf (
        lib.types.attrs {
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
        }
      );
      default = {};
      description = "A map of folder names to folder configurations.";
      example = {
        "Example" = {
          path = "/home/myusername/Example";
          devices = ["device1"];
          ignorePerms = false;
        };
      };
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
