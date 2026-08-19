{ self, ... }: {
  config = {
    custom = {
      user.extraGroups = [ "docker" ];
    };

    virtualisation = {
      containers.enable = true;
      docker = {
        enable = true;
        storageDriver = "btrfs";
        daemon.settings = {
          live-restore = false;
        };
      };
    };
  };
}
