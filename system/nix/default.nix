{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
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
    litellm_api_url = {
      sopsFile = ../secrets.yaml;
      owner = config.custom.user.name;
    };
    litellm_api_key = {
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
    systemPackages = [ pkgs.git ];
    variables = {
      CLOUDFLARE_API_TOKEN = "$(cat ${config.sops.secrets."cloudflare_api_token".path})";
      CLOUDFLARE_DEFAULT_ACCOUNT_ID = "$(cat ${
        config.sops.secrets."cloudflare_default_account_id".path
      })";
      CONTEXT7_API_KEY = "$(cat ${config.sops.secrets."context7_api_key".path})";
      SEARXNG_API_URL = "$(cat ${config.sops.secrets."searxng_api_url".path})";
      LITELLM_API_URL = "$(cat ${config.sops.secrets."litellm_api_url".path})";
      LITELLM_API_KEY = "$(cat ${config.sops.secrets."litellm_api_key".path})";
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: v: lib.isType "flake" v) inputs;
    in
    {
      # lix 2.95 (pkgs.lix / stable) is broken on current nixpkgs:
      # common-lix.nix passes -Dmimalloc=disabled but 2.95's meson.build
      # has no such option, so configure fails with
      # `ERROR: Unknown option: "mimalloc"`. Use 2.96 which supports it
      # and is already in the binary cache.
      package = pkgs.lixPackageSets.lix_2_96.lix;

      # pin the registry to avoid downloading and evaling a new nixpkgs version every time
      registry = lib.mapAttrs (_: v: { flake = v; }) flakeInputs;

      settings = {
        auto-optimise-store = true;
        builders-use-substitutes = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        flake-registry = "/etc/nix/registry.json";

        # for direnv GC roots
        keep-derivations = true;
        keep-outputs = true;

        trusted-users = [
          "root"
          "@wheel"
        ];

        system-features = [
          "kvm"
          "big-parallel"
          "nixos-test"
        ];

        accept-flake-config = false;

        # set the path for channels compat
        nix-path = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
      };

      extraOptions = ''
        !include ${config.sops.secrets.nix_access_tokens.path}
      '';
    };
}
