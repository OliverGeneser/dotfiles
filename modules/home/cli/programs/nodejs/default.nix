{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.nodejs;
in {
  options.cli.programs.nodejs = with types; {
    enable = mkBoolOpt false "Whether or not to manage Nodejs";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_23
      corepack_23
      zip
    ];

    home.sessionVariables = {
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.libuuid];
    };
  };
}
