{self, ...}: {
  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
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
