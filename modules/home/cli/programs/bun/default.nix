{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.bun;
in {
  options.cli.programs.bun = with types; {
    enable = mkBoolOpt false "Whether or not to manage Bun";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bun
    ];
  };
}
