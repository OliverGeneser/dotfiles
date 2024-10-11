{ pkgs
, inputs
, config
, lib
, ...
}:
with lib;
with lib.custom;
with types; let
  cfg = config.desktops.hyprland;
in
{
  imports = with inputs; [
    #hyprland-nix.homeManagerModules.default
    ./config.nix
    ./windowrules.nix
    ./monitors.nix
    ./keybindings.nix
  ];

  options.desktops.hyprland = {
    enable = mkEnableOption "enable hyprland window manager";
    layout = mkOpt str "us,dk" "Keyboard layout";
    variant = mkOpt str "altgr-intl," "Keyboard variant";
    options = mkOpt str "grp:alt_space_toggle," "Keyboard options";
    primary_monitor = mkOpt str "eDP-1" "Primary display";
  };

  config = mkIf cfg.enable {
    nix.settings = {
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      systemd.variables = [ "--all" ];

      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
      ];
    };

    desktops.addons = {
      gtk.enable = true;
      qt.enable = true;
      kanshi.enable = true;
      rofi.enable = true;
      dunst.enable = true;
      wlogout.enable = true;
      wlsunset.enable = true;

      pyprland.enable = true;
      hyprpaper.enable = true;
      hyprlock.enable = true;
      hypridle.enable = true;
    };
  };
}
