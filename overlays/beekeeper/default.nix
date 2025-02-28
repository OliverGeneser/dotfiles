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
  beekeeper-studio = prev.beekeeper-studio.overrideAttrs (old: {
    version = "5.1.0-beta.12";

    src = prev.fetchurl {
      url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v5.1.0-beta.12/Beekeeper-Studio-5.1.0-beta.12.AppImage";
      hash = "sha256-r8x9QpRz9I8rzfBCTGpvWXyE2tXQ1TPy9bRpA28TDn8=";
    };
  });
}
