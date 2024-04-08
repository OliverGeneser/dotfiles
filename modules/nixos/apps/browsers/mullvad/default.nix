{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.browsers.mullvad;
in {
  options.apps.browsers.mullvad = with types; {
    enable = mkBoolOpt false "Enable or disable mullvad browser";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mullvad-browser
    ];

    # home.programs.mullvad-browser = {
    #   enable = true;
    # };

    home.persist.directories = [
      ".mullvad"
      ".cache/mullvad"
    ];
  };
}
