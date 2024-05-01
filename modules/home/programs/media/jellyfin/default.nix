{ pkgs, lib, options, config, ...
}:
with lib; with lib.custom; let
  cfg = config.programs.media.jellyfin;
in { 
  options.programs.media.jellyfin = with types; { 
    enable = mkBoolOpt false "Enable or disable jellyfin media player";
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [
      jellyfin-media-player
    ];
  };
}
