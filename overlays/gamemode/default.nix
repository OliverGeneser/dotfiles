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
  gamemode = prev.gamemode.overrideAttrs (old: {
    version = "1.8.2";

    src = prev.fetchFromGitHub {
      owner = "FeralInteractive";
      repo = "gamemode";
      tag = "1.8.2";
      hash = "sha256-V0rewbSVOGFqJqXyCz4jXpuDM0EfjdkpGPl+WdDwI5I=";
    };
  });
}
