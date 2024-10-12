{ pkgs
, lib
, options
, config
, ...
}:
with lib; with lib.custom; let
  cfg = config.programs.media.vlc;
in
{
  options.programs.media.vlc = with types; {
    enable = mkBoolOpt false "Enable or disable vlc media player";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vlc
    ];
  };
}
