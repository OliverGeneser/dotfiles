{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.nodejs;
in {
  options.cli.programs.nodejs = with types; {
    enable = mkBoolOpt false "Whether or not to manage Devenv";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_22
      corepack_22
    ];
  };
}
