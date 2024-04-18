{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.custom.printing;
in {
  options.services.custom.printing = with types; {
    enable = mkBoolOpt false "Whether or not to configure printing support.";
  };

  config = mkIf cfg.enable {services.printing.enable = true;};
}
