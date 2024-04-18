{
  pkgs,
  lib,
  options,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.browsers.mullvad;
in {
  options.browsers.mullvad = with types; {
    enable = mkBoolOpt false "Enable or disable mullvad browser";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mullvad-browser
    ];
  };
}