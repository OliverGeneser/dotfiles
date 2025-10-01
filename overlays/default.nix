{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [beekeeper-studio bun opencode turso-cli];

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (final: prev: {
        version = "5.4.0";

        src = super.fetchurl {
          url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
          hash = "sha256-+IYhnsyNdPNc9pImcFk2SZpWtlpRt1kIQE9dZS06QFU=";
        };
      });
    };

    bun = self: super: {
      bun = super.bun.overrideAttrs (final: prev: {
        version = "1.2.23";

        src = super.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v1.2.23/bun-linux-x64.zip";
          hash = "sha256-zw7QqSB5nVdv/eTgyuZtcyvyPCUwQH8m9Zx4Md/+Hw4=";
        };
      });
    };

    opencode = self: super: {
      opencode = super.opencode.overrideAttrs (final: prev: {
        version = "0.13.7";

        src = prev.src.override {
          tag = "v${final.version}";
          hash = "sha256-sck2ALcOZCLjH0vJMGYMk3Jr81CGTWl/utaXlURK05o=";
        };

        tui = prev.tui.overrideAttrs (_: {
          vendorHash = "sha256-H+TybeyyHTbhvTye0PCDcsWkcN8M34EJ2ddxyXEJkZI=";
        });

        node_modules = prev.node_modules.overrideAttrs (_: {
          outputHash = "sha256-/ti2fVeoLx7yW1moQBvwmSwaW9vjp7S8EYg50gHaXFc=";
        });
      });
    };

    turso-cli = self: super: {
      turso-cli = super.turso-cli.overrideAttrs (final: prev: {
        version = "1.0.13";

        vendorHash = "sha256-tBO21IgUczwMgrEyV7scV3YTY898lYHASaLeXqvBopU=";

        src = prev.src.override {
          rev = "v${final.version}";
          hash = "sha256-zldCxXFR8zG0cpR57YvApyRsGPgqCuf7XbbrWNbuHxc=";
        };
      });
    };
  };
}
