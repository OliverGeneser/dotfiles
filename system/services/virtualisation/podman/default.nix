{
  self,
  config,
  ...
}: {
  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;

      dockerSocket.enable =
        if config.virtualisation.docker.enable
        then false
        else true;
      dockerCompat =
        if config.virtualisation.docker.enable
        then false
        else true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
      autoPrune = {
        enable = true;
        flags = ["--all"];
      };
    };
  };
}
