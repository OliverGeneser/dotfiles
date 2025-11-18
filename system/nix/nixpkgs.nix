{
  self,
  inputs,
  pkgs,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "beekeeper-studio-5.4.11"
    ];

    overlays = [
      self.overlays.default
      self.overlays.upstreams
    ];
  };
}
