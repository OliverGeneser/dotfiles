{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.starship;
in {
  options.cli.programs.starship = with types; {
    enable = mkBoolOpt false "Whether or not to enable starship";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      catppuccin.enable = true;
    };
  };
}
