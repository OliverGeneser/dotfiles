{ 
  pkgs, 
  lib, 
  config, 
  ...
}:
with lib; let
  cfg = config.programs.webcord;
in { 
  options.programs.webcord = { 
    enable = mkEnableOption "Enable webcord";
  };

  config = mkIf cfg.enable { 
    home.packages = with pkgs; [
      webcord
    ];
  };
}
