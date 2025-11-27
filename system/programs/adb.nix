{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    androidenv.androidPkgs.platform-tools
  ];
  programs.adb.enable = true;
}
