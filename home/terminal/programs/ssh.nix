{
  config,
  lib,
  pkgs,
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
      type = types.attrsOf (
        types.submodule {
          options = {
            hostname = mkOption {
              type = types.str;
              description = "The hostname or IP address of the SSH host.";
            };
            identityFile = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "The path to the identity file for the SSH host.";
            };
            identitiesOnly = mkOption {
              type = types.bool;
              default = false;
              description = "Identities only for the SSH host?";
            };
            port = mkOption {
              type = types.int;
              default = 22;
              description = "The port of the SSH host.";
            };
            user = mkOption {
              type = types.str;
              default = config.home.username;
              description = "The user of the SSH host.";
            };
            kexAlgorithms = mkOption {
              type = types.nullOr (types.listOf types.str);
              default = [
                "sntrup761x25519-sha512"
                "sntrup761x25519-sha512@openssh.com"
                "mlkem768x25519-sha256"
              ];
              description = "Specifies the available KEX (Key Exchange) algorithms.";
            };
            extraOptions = mkOption {
              type = types.attrsOf types.str;
              default = { };
              description = "Extra SSH options (like LogLevel, GSSAPIAuthentication, etc.)";
            };
          };
        }
      );
      default = { };
      description = "A set of extra SSH hosts.";
    };
  };

  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          kexAlgorithms = [
            "sntrup761x25519-sha512"
            "sntrup761x25519-sha512@openssh.com"
            "mlkem768x25519-sha256"
          ];
          forwardAgent = true;
        };
        "github.com" = {
          kexAlgorithms = [
            "sntrup761x25519-sha512"
            "sntrup761x25519-sha512@openssh.com"
            "mlkem768x25519-sha256"
            "curve25519-sha256"
            "curve25519-sha256@libssh.org"
          ];
          forwardAgent = true;
        };
      }
      // cfg.extraHosts;
      package = if cfg.withGSSAPI then pkgs.openssh_gssapi else pkgs.openssh;
    };
  };
}
