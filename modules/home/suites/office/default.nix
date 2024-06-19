{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.suites.office;
in {
  options.suites.office = with types; {
    enable = mkBoolOpt false "Whether or not to manage office configuration";
  };

  config = mkIf cfg.enable {
    programs.libreoffice = {
      enable = true;
    };
  };
}
