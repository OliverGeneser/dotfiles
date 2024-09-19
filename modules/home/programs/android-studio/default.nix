{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.programs.androidStudio;
in
{
  options.programs.androidStudio = {
    enable = mkEnableOption "Enable Android Studio";
  };

  config = mkIf cfg.enable {
    nixpkgs = {
        config = {
          android_sdk.accept_license = true;
        };
      };
    home.packages = with pkgs; [
      #android-tools
      android-studio-full
     # gradle
     # kotlin
      #jdk21
    ];
  };
}
