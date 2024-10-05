{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.roles.office;
in {
  options.roles.office = with types; {
    enable = mkBoolOpt false "Whether or not to manage office configuration";
  };

  config = mkIf cfg.enable {
    programs.libreoffice = {
      enable = true;
    };
  };
}
