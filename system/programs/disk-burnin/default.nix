{pkgs, ...}: let
  # https://github.com/Spearfoot/disk-burnin-and-testing
  disk-burnin = pkgs.writeShellScriptBin "disk-burnin.sh" (builtins.readFile ./disk-burnin);
in {
  environment.systemPackages = [
    disk-burnin
    pkgs.e2fsprogs
  ];
}
