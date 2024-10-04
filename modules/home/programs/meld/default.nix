{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.programs.meld;
in
{
  options.programs.meld = {
    enable = mkEnableOption "Enable meld";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      meld
    ];
  };
}
