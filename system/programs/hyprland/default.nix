{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default

    ./binds.nix
    ./rules.nix
    ./settings.nix
    ./smartgaps.nix
  ];

  environment.systemPackages = [
    inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system}.grimblast
    pkgs.hyprpolkitagent
  ];

  environment.pathsToLink = ["/share/icons"];

  # enable hyprland and required options
  programs.hyprland = {
    enable = true;
    withUWSM = true;

    plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
      csgo-vulkan-fix
      # hyprbars
      # hyprexpo
    ];

    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # tell Electron/Chromium to run on Wayland
  environment.variables.NIXOS_OZONE_WL = "1";
}
