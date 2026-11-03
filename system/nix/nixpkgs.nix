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
      "beekeeper-studio-6.2.1"
    ];
    # lutris' FHS env still hard-depends on gtk2, which is flagged for removal
    # (https://github.com/NixOS/nixpkgs/issues/410814)
    config.problems.handlers."gtk+".broken = "warn";

    overlays = [
      self.overlays.default
      self.overlays.upstreams
    ];
  };
}
