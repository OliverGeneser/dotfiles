{ config
, lib
, pkgs
, ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.act;
in
{
  options.cli.programs.act = with types; {
    enable = mkBoolOpt false "Whether or not to enable act";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      act
    ];
  };
}
