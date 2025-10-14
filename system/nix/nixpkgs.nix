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
      "beekeeper-studio-5.4.1"
      "qtwebengine-5.15.19"
    ];

    overlays = [
      self.overlays.default
      self.overlays.upstreams
    ];
  };
}
