{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.terminal.programs.ssh;
in {
  options.terminal.programs.ssh = {
    extraHosts = mkOption {
      type = types.attrsOf (types.submodule {
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
            default =
              config.home.username;
            description = "The user of the SSH host.";
          };
        };
      });
      default = {};
      description = "A set of extra SSH hosts.";
      example = types.literalExample ''
        {
          "gitlab-personal" = {
            hostname = "gitlab.com";
            identityFile = "~/.ssh/id_ed25519_personal";
          };
        }
      '';
    };
  };

  config = {
    programs.ssh = {
      enable = true;
      matchBlocks = cfg.extraHosts;
    };
  };
}
