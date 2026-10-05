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
      "beekeeper-studio-6.1.5"
    ];

    overlays = [
      self.overlays.default
      self.overlays.upstreams
    ];
  };
}
