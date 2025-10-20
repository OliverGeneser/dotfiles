{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [beekeeper-studio bun homepage-dashboard opencode turso-cli];

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

    homepage-dashboard = self: super: {
      homepage-dashboard = super.homepage-dashboard.overrideAttrs (final: prev: {
        installPhase = ''
          runHook preInstall

          mkdir -p $out/{bin,share}
          cp -r .next/standalone $out/share/homepage/
          cp -r public $out/share/homepage/public
          chmod +x $out/share/homepage/server.js

          mkdir -p $out/share/homepage/.next
          cp -r .next/static $out/share/homepage/.next/static

          makeWrapper "${super.lib.getExe super.nodejs}" $out/bin/homepage \
            --set-default PORT 3000 \
            --set-default HOMEPAGE_CONFIG_DIR /var/lib/homepage-dashboard \
            --set-default NIXPKGS_HOMEPAGE_CACHE_DIR /var/cache/homepage-dashboard \
            --add-flags "$out/share/homepage/server.js" \
            --prefix PATH : "${super.lib.makeBinPath [super.unixtools.ping]}"

          runHook postInstall
        '';
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
