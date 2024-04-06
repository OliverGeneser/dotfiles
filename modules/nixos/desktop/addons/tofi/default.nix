{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.tofi;
in {
  options.desktop.addons.tofi = with types; {
    enable = mkBoolOpt false "Enable or disable the tofi run launcher.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tofi
    ];

    home.configFile."tofi/config".source = ./config;
  };
}
