# Snowfall Lib provides access to additional information via a primary argument of
# your overlay.
{
  # Channels are named after NixPkgs instances in your flake inputs. For example,
  # with the input `nixpkgs` there will be a channel available at `channels.nixpkgs`.
  # These channels are system-specific instances of NixPkgs that can be used to quickly
  # pull packages into your overlay.
  channels,
  # The namespace used for your Flake, defaulting to "internal" if not set.
  # Inputs from your flake.
  inputs,
  ...
}: final: prev: {
  docker-compose = prev.docker-compose.overrideAttrs (old: {
    vendorHash = "sha256-6KLdDBuPiB/qh+3IfABu8Gvopu5ucTrNg9jh7G+cMss=";
    #  goModules = prev.fetchurl {
    #    url = "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-linux-x86_64";
    #    hash = "sha256-Q/s5wLwkrHlhI5NQMu3c+1enrNkha63rEHFMmG6h4JA="; # Corrected hash
    #  };
  });
}
