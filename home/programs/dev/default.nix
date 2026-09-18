{ pkgs, ... }: {
  imports = [
    ./beekeeper-studio.nix
    ./bruno.nix
    ./openshift.nix
    ./t3code.nix
  ];

  home.packages = with pkgs; [
    gitbutler
  ];
}
