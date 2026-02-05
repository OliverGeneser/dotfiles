{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs_24
    corepack_24
    zip
  ];

  programs.npm.enable = true;

  home.sessionVariables = {
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.libuuid];
  };
}
