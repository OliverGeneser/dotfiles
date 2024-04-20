{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.fzf;
in {
  options.cli.programs.fzf = with types; {
    enable = mkBoolOpt false "Whether or not to enable fzf";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableFishIntegration = false;
      catppuccin.enable = true;
    };
  };
}
