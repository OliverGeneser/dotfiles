{pkgs, ...}: {
  home.packages = with pkgs; [
    uv
    python3
  ];
}
