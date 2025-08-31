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
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    pkgs.hyprpolkitagent
  ];

  environment.pathsToLink = ["/share/icons"];

  # enable hyprland and required options
  programs.hyprland = {
    enable = true;
    withUWSM = true;

    plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
      # hyprbars
      # hyprexpo
    ];

    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  # tell Electron/Chromium to run on Wayland
  environment.variables.NIXOS_OZONE_WL = "1";
}
