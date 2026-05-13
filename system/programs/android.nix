{ pkgs, ... }:
{
  nixpkgs.config.android_sdk.accept_license = true;

  environment.sessionVariables = rec {
    ANDROID_HOME = "$HOME/Android/Sdk";
    ANDROID_AVD_HOME = "$HOME/.config/.android/avd";
    PATH = "$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools";
  };

  environment.systemPackages = with pkgs; [
    android-studio
    watchman
    jdk
  ];
}
