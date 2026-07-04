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
      "pnpm-10.29.2"
    ];

    overlays = [
      self.overlays.default
      self.overlays.upstreams
    ];
  };
}
