{ config
, lib
, ...
}:
with lib; let
  cfg = config.desktops.addons.dunst;
in
{
  options.desktops.addons.dunst = {
    enable = mkEnableOption "Enable dunst";
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      waylandDisplay = "wayland-1";
    };
  };
}
