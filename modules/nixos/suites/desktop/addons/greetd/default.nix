{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.suites.desktop.addons.greetd;
in {
  options.suites.desktop.addons.greetd = {
    enable = mkEnableOption "Enable login greeter";
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = rec {
        default_session = {
          command = "Hyprland &> /dev/null";
          user = config.user.name;
        };
        initial_session = default_session;
      };
    };
  };
}
