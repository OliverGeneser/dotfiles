{
  config,
  lib,
  pkgs,
  options,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.terminal.programs.ssh;
in
{
  options.terminal.programs.ssh = {
    withGSSAPI = mkOption {
      type = types.bool;
      default = false;
      description = "Enable GSSAPIAuthentication";
    };

    extraHosts = mkOption {
      type = options.programs.ssh.settings.type;
      default = { };
      description = "A set of extra SSH hosts.";
    };
  };

  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          KexAlgorithms = [
            "sntrup761x25519-sha512"
            "sntrup761x25519-sha512@openssh.com"
            "mlkem768x25519-sha256"
          ];
          ForwardAgent = true;
        };
        "github.com" = {
          KexAlgorithms = [
            "sntrup761x25519-sha512"
            "sntrup761x25519-sha512@openssh.com"
            "mlkem768x25519-sha256"
            "curve25519-sha256"
            "curve25519-sha256@libssh.org"
          ];
          ForwardAgent = true;
        };
      }
      // cfg.extraHosts;
      package = if cfg.withGSSAPI then pkgs.openssh_gssapi else pkgs.openssh;
    };
  };
}
