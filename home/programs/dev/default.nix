{pkgs, ...}: {
  imports = [
    ./beekeeper-studio.nix
    ./bruno.nix
  ];

  home.packages = with pkgs; [
    gitbutler
  ];
}
