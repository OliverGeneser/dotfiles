{ pkgs, ... }:
let
  sdk = "$HOME/Android/Sdk";
in
{
  nixpkgs.config.android_sdk.accept_license = true;

  environment.sessionVariables = {
    ANDROID_HOME = sdk;
    ANDROID_AVD_HOME = "$HOME/.config/.android/avd";
    PATH = [
      "${sdk}/emulator"
      "${sdk}/platform-tools"
    ];
  };

  environment.systemPackages = with pkgs; [
    android-studio
    watchman
    jdk
  ];
}
