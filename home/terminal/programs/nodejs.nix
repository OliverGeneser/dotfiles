{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs_23
    corepack_23
    zip
  ];

  home.sessionVariables = {
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.libuuid];
  };
}
