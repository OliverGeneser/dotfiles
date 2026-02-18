{pkgs, ...}: {
  home.packages = with pkgs; [
    openshift
  ];
}
