{
  self,
  pkgs,
  ...
}: {
  home.packages = [
    self.packages.${pkgs.stdenv.hostPlatform.system}.helium
  ];
}
