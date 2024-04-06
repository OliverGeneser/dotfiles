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
  cfg = config.desktop.addons.mako;
in {
  options.desktop.addons.mako = with types; {
    enable = mkBoolOpt false "Enable or disable mako";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mako
      libnotify
    ];

    home.configFile."mako/config" = {
      text = ''
        background-color=#ffffff
        text-color=#$ffffff
        border-color=#ffffff
        progress-color=over #ffffff

        [urgency=high]
        border-color=#ffffff
      '';
      onChange = ''
        ${pkgs.busybox}/bin/pkill -SIGUSR2 mako
      '';
    };
  };
}
