{ config
, lib
, pkgs
, ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.sqlite;
in
{
  options.cli.programs.sqlite = with types; {
    enable = mkBoolOpt false "Whether or not to enable sqlite";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sqlite
    ];
  };
}
