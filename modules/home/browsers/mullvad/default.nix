{
  options,
  config,
  pkgs,
  lib,
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
    environment.systemPackages = with pkgs; [
      mullvad-browser
    ];
  };
}