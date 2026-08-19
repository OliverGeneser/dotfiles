{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ pyprland ];
  };
  xdg.configFile."hypr/pyprland.toml".source = ./pyprland.toml;
}
