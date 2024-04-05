{
  options,
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

  
    # home.configFile."git/config".text = import ./config.nix {sshKeyPath = "/home/${config.user.name}/.ssh/key.pub"; name = ""; email = "";};



    # Actual Shell Configurations
    home.programs.wezterm = mkIf (cfg.terminal == "wezterm") {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
    };

  };
}
