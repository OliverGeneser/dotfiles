{ inputs
, config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.cli.terminals.wezterm;
in
{
  options.cli.terminals.wezterm = {
    enable = mkEnableOption "enable wezterm terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
      extraConfig = builtins.readFile ./config.lua;
    };
    xdg.configFile."wezterm/sessionizer.lua".source = ./sessionizer.lua;
  };
}
