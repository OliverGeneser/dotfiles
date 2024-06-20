{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.ssh;
in {
  options.cli.programs.ssh = with types; {
    enable = mkBoolOpt false "Whether or not to enable ssh";

    extraHosts = mkOption {
      type = lib.types.anything;
      description = "Extra SSH match blocks.";
      default = [];
    };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;

      matchBlocks = cfg.extraHosts;
    };
  };
}
