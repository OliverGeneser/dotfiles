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
  SDL2_image = prev.SDL2_image.overrideAttrs (old: {
    src = prev.fetchurl {
      url = "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-${old.version}.tar.gz";
      hash = "sha256-98Bqh4OVLP6WCtzN09hHK2OrMUdbQ5DRDP3MGuphI48=";
    };
  });
}
