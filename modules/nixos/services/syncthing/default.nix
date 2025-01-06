{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.custom.syncthing;
in {
  options.services.custom.syncthing = with types; {
    enable = mkBoolOpt false "Enable Syncthing";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;

      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI

      guiAddress = "0.0.0.0:8384";

      settings = {
        gui = {
          user = "${config.user.name}";
          password = "password";
        };

        devices = {
          "oliver" = {
            id = "EVZY72B-QB2I3KS-IQIXSPN-EV7Y3BX-TXJFDXZ-HISKJIB-MS6XVKT-QDDZQQS";
          };
        };

        folders = {
          # Name of folder in Syncthing, also the folder ID
          "Oliver Photos" = {
            id = "hd1901_jc5r-photos";
            path = "/mnt/storage/homes/Oliver/Syncthing"; # Which folder to add to Syncthing
            devices = ["oliver"]; # Which devices to share the folder with
          };
        };
      };
    };
  };
}
