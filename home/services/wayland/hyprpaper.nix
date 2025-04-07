{
  pkgs,
  inputs,
  config,
  ...
}: {
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.system}.default;

    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
    };
  };
}
