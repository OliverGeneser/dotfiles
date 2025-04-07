{pkgs, ...}: {
  home.packages = with pkgs; [
    uv
    python313
  ];
}
