{
  pkgs,
  inputs,
  ...
}: {
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
    };
  };
}
