{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.browsers.chromium;
in {
  options.browsers.chromium = with types; {
    enable = mkBoolOpt false "Enable or disable chromium browser";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ungoogled-chromium
    ];
  };
}
