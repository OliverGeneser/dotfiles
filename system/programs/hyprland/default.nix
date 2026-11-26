{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [
    ./variables.nix
  ];

  environment = {
    systemPackages = [
      inputs.hyprland-contrib.packages.${system}.grimblast
      pkgs.hyprpolkitagent
      pkgs.satty
    ];

    # tell Electron/Chromium to run on Wayland
    variables.NIXOS_OZONE_WL = "1";

    etc =
      let
        lua = [
          ./animations.lua
          ./binds.lua
          ./hyprland.lua
          ./rules.lua
          ./settings.lua
          ./smartgaps.lua
        ];
      in
      builtins.listToAttrs (
        map (e: {
          name = "xdg/hypr/${lib.baseNameOf e}";
          value = {
            source = e;
          };
        }) lua
      );
  };

  # enable hyprland and required options
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${system}.default;

    #plugins = with inputs.hyprland-plugins.packages.${system}; [
    # csgo-vulkan-fix
    #];
  };
}
