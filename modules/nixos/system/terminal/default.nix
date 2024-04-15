{
  options,
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.terminal;
in {
  options.system.terminal = with types; {
    terminal = mkOpt (enum ["wezterm"]) "wezterm" "What terminal to use";
  };

  config = {
    environment.systemPackages = with pkgs; [
      
    ];

    # Actual Shell Configurations
    home.programs.wezterm = mkIf (cfg.terminal == "wezterm") {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
    };

    home.configFile."wezterm/wexterm.lua".text = import ./config.nix {terminal = "${cfg.terminal}";};

    home.persist.directories = [
      ".config/wezterm"
    ];

  };
}
