{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.python;
in {
  options.cli.programs.python = with types; {
    enable = mkBoolOpt false "Whether or not to manage Python";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      uv
      python313
    ];
  };
}
