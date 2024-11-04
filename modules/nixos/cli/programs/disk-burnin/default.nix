{ config
, lib
, pkgs
, ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.disk-burnin;
  disk-burnin = pkgs.writeShellScriptBin "disk-burnin.sh" (builtins.readFile ./disk-burnin);
in
{
  options.cli.programs.disk-burnin = {
    enable = mkEnableOption "Enable disk burnin script";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      disk-burnin
      pkgs.e2fsprogs
    ];
  };
}
