{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./binds.nix
    ./rules.nix
    ./settings.nix
    ./smartgaps.nix
  ];

  home.packages = [
    inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system}.grimblast
    pkgs.libinput
  ];

  # enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;

    package = inputs.hyprland.packages.${system}.default;
    # package = inputs.hyprland.packages.${system}.default.overrideAttrs {
    #   patches = [../../../../overlays/patch-hyprland-glaze.patch];
    # };

    plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
      # hyprbars
      # hyprexpo
    ];

    systemd = {
      enable = false;
      variables = [ "--all" ];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };
}
