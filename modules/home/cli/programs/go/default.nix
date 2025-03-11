{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.go;
in {
  options.cli.programs.go = with types; {
    enable = mkBoolOpt false "Whether or not to manage Go";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      air
    ];
  };
}
