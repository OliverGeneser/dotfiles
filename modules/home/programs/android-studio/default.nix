{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.androidStudio;
in {
  options.programs.androidStudio = {
    enable = mkEnableOption "Enable Android Studio";
  };

  config = mkIf cfg.enable {
    nixpkgs = {
      config = {
        android_sdk.accept_license = true;
      };
    };

    home.sessionVariables = {
      NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE = 1;
    };

    home.packages = with pkgs; [
      #android-tools
      android-studio
      # gradle
      # kotlin
      #jdk21
    ];
  };
}
