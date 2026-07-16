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
      #"pnpm-10.29.2"
      "electron-40.10.5"
    ];

    overlays = [
      self.overlays.default
      self.overlays.upstreams
    ];
  };
}
