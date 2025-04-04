{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.nix;
in {
  options.system.nix = with types; {
    enable = mkBoolOpt false "Whether or not to manage nix configuration";
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      nix_access_tokens = {
        sopsFile = ../../secrets.yaml;
      };
      openrouter_api_key = {
        sopsFile = ../../secrets.yaml;
        owner = config.user.name;
      };
    };

    environment.sessionVariables = {
      OPENROUTER_API_KEY = "$(cat ${config.sops.secrets."openrouter_api_key".path})";
    };

    nix = {
      settings = {
        trusted-users = ["@wheel" "root"];
        auto-optimise-store = lib.mkDefault true;
        use-xdg-base-directories = true;
        experimental-features = ["nix-command" "flakes"];
        warn-dirty = false;
        system-features = ["kvm" "big-parallel" "nixos-test"];
      };

      extraOptions = ''
        !include ${config.sops.secrets.nix_access_tokens.path}
      '';

      # flake-utils-plus
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}
