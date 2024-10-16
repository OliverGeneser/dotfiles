{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.httpie;
in {
  options.programs.httpie = {
    enable = mkEnableOption "Enable HTTPie  ";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      httpie
    ];
  };
}
