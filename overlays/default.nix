{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [beekeeper-studio bun opencode turso-cli];

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (final: prev: {
        version = "5.4.9";

        src = super.fetchurl {
          url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
          hash = "sha256-KKZmjSemVv+suwAtiAArGzWImEyqaq+OMisr380mlOE=";
        };
      });
    };

    bun = self: super: {
      bun = super.bun.overrideAttrs (final: prev: {
        version = "1.3.0";

        src = super.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.0/bun-linux-x64.zip";
          hash = "sha256-YMOdkri9CQYnUkyYswEvDAjciQJM/ap8nJjLX9Q1k3Y=";
        };
      });
    };

    opencode = self: super: {
      opencode = super.opencode.overrideAttrs (final: prev: {
        version = "0.15.8";

        src = prev.src.override {
          tag = "v${final.version}";
          hash = "sha256-6brfh6yTFGnhUo9kZ5VAcC1whhMPJYYwVIT7j6g+wkw=";
        };

        tui = prev.tui.overrideAttrs (_: {
          vendorHash = "sha256-g3+2q7yRaM6BgIs5oIXz/u7B84ZMMjnxXpvFpqDePU4=";
        });

        node_modules = prev.node_modules.overrideAttrs (_: {
          outputHash = "sha256-EfH8fBgP0zsKVu26BxFq1NCwWLG6vlOhDD/WQ7152hA=";
        });
      });
    };

    turso-cli = self: super: {
      turso-cli = super.turso-cli.overrideAttrs (final: prev: {
        version = "1.0.15";

        vendorHash = "sha256-tBO21IgUczwMgrEyV7scV3YTY898lYHASaLeXqvBopU=";

        src = prev.src.override {
          rev = "v${final.version}";
          hash = "sha256-c4RtEqMCpRgr4p6STWrRv7+UIA11WySTNhyvkLgzRso=";
        };
      });
    };
  };
}
