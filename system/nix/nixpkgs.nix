{
  self,
  inputs,
  system,
  pkgs,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "electron-25.9.0"
      "electron-32.3.3"
      "beekeeper-studio-5.1.5"
    ];

    overlays = [
      self.overlays.default
      self.overlays.upstreams
    ];
  };
}
