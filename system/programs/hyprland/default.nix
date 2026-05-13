{
  inputs,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [
    inputs.hyprland.nixosModules.default

    ./binds.nix
    ./rules.nix
    ./settings.nix
    ./smartgaps.nix
  ];

  environment.systemPackages = [
    inputs.hyprland-contrib.packages.${system}.grimblast
    pkgs.hyprpolkitagent
    pkgs.satty
  ];

  # enable hyprland and required options
  programs.hyprland = {
    enable = true;
    withUWSM = true;

    xwayland.enable = true;

    plugins = with inputs.hyprland-plugins.packages.${system}; [
      # csgo-vulkan-fix
      # hyprbars
    ];

    package = inputs.hyprland.packages.${system}.default;
    # package = inputs.hyprland.packages.${system}.default.overrideAttrs {
    #   patches = [../../../overlays/patch-hyprland-glaze.patch];
    # };
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };

  # tell Electron/Chromium to run on Wayland
  environment.variables.NIXOS_OZONE_WL = "1";
}
