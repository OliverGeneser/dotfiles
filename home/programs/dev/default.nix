{ pkgs, ... }:
{
  imports = [
    ./beekeeper-studio.nix
    ./bruno.nix
    ./openshift.nix
  ];

  home.packages = with pkgs; [
    gitbutler
  ];
}
