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
  flasgger = prev.flasgger.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "flasgger";
      repo = "flasgger";
      rev = "v0.9.7.1";
      hash = "sha256-ULEf9DJiz/S2wKlb/vjGto8VCI0QDcm0pkU5rlOwtiE="; # Corrected hash
    };
  });

  python312Packages = prev.python312Packages.overrideScope (self: super: {
    flasgger = prev.python312Packages.flasgger.overrideAttrs (oldAttrs: rec {
      src = prev.fetchFromGitHub {
        owner = "flasgger";
        repo = "flasgger";
        rev = "0.9.7.1";
        hash = "sha256-ULEf9DJiz/S2wKlb/vjGto8VCI0QDcm0pkU5rlOwtiE="; # Corrected hash
      };
    });
  });

  python3Packages = prev.python3Packages.overrideScope (self: super: {
    flasgger = prev.flasgger.overrideAttrs (oldAttrs: rec {
      version = "0.9.7.1";
      src = prev.fetchFromGitHub {
        owner = "flasgger";
        repo = "flasgger";
        rev = "v0.9.7.1";
        hash = "sha256-ULEf9DJiz/S2wKlb/vjGto8VCI0QDcm0pkU5rlOwtiE=";
      };
    });
  });
}
