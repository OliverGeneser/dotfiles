# Snowfall Lib provides access to additional information via a primary argument of
# your overlay.
{
  # Channels are named after NixPkgs instances in your flake inputs. For example,
  # with the input `nixpkgs` there will be a channel available at `channels.nixpkgs`.
  # These channels are system-specific instances of NixPkgs that can be used to quickly
  # pull packages into your overlay.
  channels,
  # The namespace used for your Flake, defaulting to "internal" if not set.
  #namespace,
  # Inputs from your flake.
  inputs,
  ...
}: final: prev: {
  super-slicer-custom = prev.super-slicer-beta.overrideAttrs (old: {
    version = "2.5.59.12";

    src = prev.fetchFromGitHub {
      owner = "supermerill";
      repo = "SuperSlicer";
      rev = "2.5.59.13";
      # If you don't know the hash, the first time, set:
      # hash = "";
      # then nix will fail the build with such an error message:
      # hash mismatch in fixed-output derivation '/nix/store/m1ga09c0z1a6n7rj8ky3s31dpgalsn0n-source':
      # specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
      # got:    sha256-173gxk0ymiw94glyjzjizp8bv8g72gwkjhacigd1an09jshdrjb4
      hash = "sha256-FkoGcgVoBeHSZC3W5y30TBPmPrWnZSlO66TgwskgqAU=";
      fetchSubmodules = true;
    };
  });
}
