{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.aws;
in {
  options.cli.programs.aws = with types; {
    enable = mkBoolOpt false "Whether or not to enable aws";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      awscli2
    ];
  };
}
