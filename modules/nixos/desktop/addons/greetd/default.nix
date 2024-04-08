{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop.addons.greetd;
in {
  options.desktop.addons.greetd = {
    enable = mkEnableOption "Enable login greeter";
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = rec {
        default_session = {
          command = "Hyprland";
          # TODO: make this configurable using snowfall username
          user = "olivergeneser";
        };
        initial_session = default_session;
      };
    };
  };
}
