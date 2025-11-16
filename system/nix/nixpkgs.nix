{
  self,
  inputs,
  pkgs,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "beekeeper-studio-5.4.10"
    ];

    overlays = [
      self.overlays.default
      self.overlays.upstreams
    ];
  };
}
