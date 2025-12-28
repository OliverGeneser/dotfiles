{
  self,
  inputs,
  pkgs,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "beekeeper-studio-5.5.3"
    ];

    overlays = [
      self.overlays.default
      self.overlays.upstreams
    ];
  };
}
