{
  inputs,
  withSystemVencord,
  ...
}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [beekeeper-studio bun turso-cli];

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (final: prev: {
        version = "5.6.2";

        src = super.fetchurl {
          url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
          hash = "sha256-s1Smb8du7pZjcVMnLsJ39P28erApDLnf5lqO9rO7asw=";
        };
      });
    };

    bun = self: super: {
      bun = super.bun.overrideAttrs (final: prev: {
        version = "1.3.11";

        src = super.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v${final.version}/bun-linux-x64.zip";
          hash = "sha256-hhG6k1r4hvBabzh0ChUWAybBXl1dB63vlmEwtEk2B+0=";
        };
      });
    };

    nvidia = self: super: {
      linuxPackages_latest = super.linuxPackages_latest.extend (lpFinal: lpPrev: {
        nvidiaPackages =
          lpPrev.nvidiaPackages
          // {
            beta =
              lpPrev.nvidiaPackages.beta
              // {
                open = lpPrev.nvidiaPackages.beta.open.overrideAttrs (old: {
                  patches =
                    (old.patches or [])
                    ++ [
                      ./patch-nvidia.patch
                    ];
                });
              };
          };
      });
    };

    turso-cli = self: super: {
      turso-cli = super.turso-cli.overrideAttrs (final: prev: {
        version = "1.0.17";

        vendorHash = "sha256-Cb4/KA9jfI/pNHbJqLWtm9oEXfMHGBS46J9o3lL4/Tk=";

        src = prev.src.override {
          rev = "v${final.version}";
          hash = "sha256-3u5yc49v0vwNKaI5GcE+rDEoscbQqpnaN11Bax0SEtE=";
        };
      });
    };
  };
}
