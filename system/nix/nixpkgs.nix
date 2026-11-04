{
  self,
  inputs,
  pkgs,
  ...
}:
{
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [ ];

    overlays = [
      self.overlays.default
      self.overlays.upstreams
    ];
  };
}
