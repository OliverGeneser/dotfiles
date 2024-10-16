{ config
, lib
, pkgs
, ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.programs.nix-ld;
in
{
  options.cli.programs.nix-ld = with types; {
    enable = mkBoolOpt false "Whether or not to enable nix-ld.";
  };

  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;

      # Sets up all the libraries to load
      libraries = with pkgs; [
        stdenv.cc.cc # commonly needed
        zlib # commonly needed
        openssl # commonly needed
      ];
    };
  };

}
