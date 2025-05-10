{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./nh.nix
    ./nix-ld.nix
    ./nixpkgs.nix
    ./substituters.nix
  ];

  sops.secrets = {
    nix_access_tokens = {
      sopsFile = ../secrets.yaml;
    };
    openrouter_api_key = {
      sopsFile = ../secrets.yaml;
      owner = config.custom.user.name;
    };
  };

  environment = {
    systemPackages = [pkgs.git];
    sessionVariables = {
      OPENROUTER_API_KEY = "$(cat ${config.sops.secrets."openrouter_api_key".path})";
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: v: lib.isType "flake" v) inputs;
  in {
    package = pkgs.lix;

    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: {flake = v;}) flakeInputs;

    # set the path for channels compat
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "/etc/nix/registry.json";

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      trusted-users = ["root" "@wheel"];

      system-features = ["kvm" "big-parallel" "nixos-test"];

      accept-flake-config = false;
    };

    extraOptions = ''
      !include ${config.sops.secrets.nix_access_tokens.path}
    '';
  };
}
