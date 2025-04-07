{pkgs, ...}: {
  home.packages = with pkgs; [
    arion
    podman
    podman-compose
    podman-tui
  ];
}
