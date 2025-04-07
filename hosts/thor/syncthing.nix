{config, ...}: {
  services.syncthing = {
    settings = {
      devices = {
        "oliver" = {
          id = "EVZY72B-QB2I3KS-IQIXSPN-EV7Y3BX-TXJFDXZ-HISKJIB-MS6XVKT-QDDZQQS";
        };
      };

      folders = {
        # Name of folder in Syncthing, also the folder ID
        "Oliver Photos" = {
          id = "hd1901_jc5r-photos";
          path = "/mnt/storage/vault/homes/Oliver/Syncthing/Photos"; # Which folder to add to Syncthing
          devices = ["oliver"]; # Which devices to share the folder with
        };
      };
    };
  };
}
