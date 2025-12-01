{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./appimage.nix
    ./nh.nix
    ./nix-ld.nix
    ./nixpkgs.nix
    ./substituters.nix
  ];

  sops.secrets = {
    cloudflare_api_token = {
      sopsFile = ../secrets.yaml;
      owner = config.custom.user.name;
    };
    cloudflare_default_account_id = {
      sopsFile = ../secrets.yaml;
      owner = config.custom.user.name;
    };
    context7_api_key = {
      sopsFile = ../secrets.yaml;
      owner = config.custom.user.name;
    };
    nix_access_tokens = {
      sopsFile = ../secrets.yaml;
      owner = config.custom.user.name;
    };
    searxng_api_url = {
      sopsFile = ../secrets.yaml;
      owner = config.custom.user.name;
    };
  };

  environment = {
    systemPackages = [pkgs.git];
    sessionVariables = {
      CLOUDFLARE_API_TOKEN = "$(cat ${config.sops.secrets."cloudflare_api_token".path})";
      CLOUDFLARE_DEFAULT_ACCOUNT_ID = "$(cat ${config.sops.secrets."cloudflare_default_account_id".path})";
      CONTEXT7_API_KEY = "$(cat ${config.sops.secrets."context7_api_key".path})";
      SEARXNG_API_URL = "$(cat ${config.sops.secrets."searxng_api_url".path})";
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
