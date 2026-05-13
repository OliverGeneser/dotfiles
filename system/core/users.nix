{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.custom.user;
in
{
  options.custom.user = {
    name = mkOption {
      type = types.str;
      default = "olivergeneser";
      description = "The name of the user account.";
    };

    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Groups for the user to be assigned.";
    };

    extraOptions = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra options passed to users.users.<name>";
    };
  };

  config = {
    sops.secrets.password = {
      sopsFile = ../secrets.yaml;
      neededForUsers = true;
    };

    users.mutableUsers = false;
    users.users.${cfg.name} = {
      isNormalUser = true;
      shell = pkgs.zsh;

      # initialPassword = "test1234";
      hashedPasswordFile = config.sops.secrets.password.path;

      extraGroups = [
        "adbusers"
        "input"
        "libvirtd"
        "networkmanager"
        "plugdev"
        "podman"
        "transmission"
        "video"
        "wheel"
        "kvm"
      ]
      ++ cfg.extraGroups;
    }
    // cfg.extraOptions;
  };
}
