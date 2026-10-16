{
  self,
  inputs,
  pkgs,
  ...
}:
{
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "beekeeper-studio-6.1.6"
    ];

    overlays = [
      self.overlays.default
      self.overlays.upstreams
    ];
  };
}
