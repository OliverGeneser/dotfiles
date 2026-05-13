{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.programs.browsers.zen;
in
{
  options.programs.browsers.zen = {
    package = mkOption {
      description = "Package to use for zen";
      type = types.package;
      default = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight;
    };
  };

  config = {
    home.packages = [
      cfg.package
    ];
  };
}
