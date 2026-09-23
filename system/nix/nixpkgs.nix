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
      "electron-40.10.5"
      "beekeeper-studio-6.1.2"
    ];

    overlays = [
      self.overlays.default
      self.overlays.upstreams
    ];
  };
}
