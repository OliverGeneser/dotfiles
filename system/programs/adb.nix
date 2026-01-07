{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pkgs.android-tools
    androidenv.androidPkgs.platform-tools
  ];
}
