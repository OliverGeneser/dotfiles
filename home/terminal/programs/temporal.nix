{ pkgs, ... }: {
  home.packages = with pkgs; [
    temporal-cli
  ];
}
