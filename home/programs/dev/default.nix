{pkgs, ...}: {
  imports = [
    ./httpie.nix
    ./beekeeper-studio.nix
  ];

  home.packages = with pkgs; [
    gitbutler
  ];
}
