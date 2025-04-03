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
  tcp_wrappers = prev.tcp_wrappers.overrideAttrs (old: {
    version = "7.6.q-36";

    src = final.fetchurl {
      url = "mirror://debian/pool/main/t/tcp-wrappers/tcp-wrappers_7.6.q.orig.tar.gz";
      sha256 = "0p9ilj4v96q32klavx0phw9va21fjp8vpk11nbh6v2ppxnnxfhwm";
    };

    debian = final.fetchurl {
      url = "mirror://debian/pool/main/t/tcp-wrappers/tcp-wrappers_7.6.q-36.debian.tar.xz";
      hash = "sha256-t5W+9XKwNR1ecH49fop3ses4Ga2bUIiV/x/JqCa2z6Q=";
    };
  });
}
