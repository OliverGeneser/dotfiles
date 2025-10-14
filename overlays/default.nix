{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [beekeeper-studio bun opencode turso-cli];

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (final: prev: {
        version = "5.4.1";

        src = super.fetchurl {
          url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
          hash = "sha256-K2/pAZw3kdhiFUboJSeWrqq0HT5aS4b+NPSJR56rM3A=";
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
        version = "0.15.0";

        src = prev.src.override {
          tag = "v${final.version}";
          hash = "sha256-WTWLh50atZ0P+S0BIgInRoaQV94wIO7NJXrpnsiXTAU=";
        };

        tui = prev.tui.overrideAttrs (_: {
          vendorHash = "sha256-g3+2q7yRaM6BgIs5oIXz/u7B84ZMMjnxXpvFpqDePU4=";
        });

        node_modules = prev.node_modules.overrideAttrs (_: {
          buildPhase = ''
            runHook preBuild

            export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

            # NOTE: Disabling post-install scripts with `--ignore-scripts` to avoid
            # shebang issues
            # NOTE: `--linker=hoisted` temporarily disables Bun's isolated installs,
            # which became the default in Bun 1.3.0.
            # See: https://bun.com/blog/bun-v1.3#isolated-installs-are-now-the-default-for-workspaces
            # This workaround is required because the 'yargs' dependency is currently
            # missing when building opencode. Remove this flag once upstream is
            # compatible with Bun 1.3.0.
            bun install \
              --filter=opencode \
              --force \
              --frozen-lockfile \
              --ignore-scripts \
              --linker=hoisted \
              --no-progress \
              --production

            runHook postBuild
          '';
          outputHash = "sha256-kXsLJ/Ck9epH9md6goCj3IYpWog/pOkfxJDYAxI14Fg=";
        });
      });
    };

    turso-cli = self: super: {
      turso-cli = super.turso-cli.overrideAttrs (final: prev: {
        version = "1.0.14";

        vendorHash = "sha256-tBO21IgUczwMgrEyV7scV3YTY898lYHASaLeXqvBopU=";

        src = prev.src.override {
          rev = "v${final.version}";
          hash = "sha256-1wvr2E1sYcDSelTxfl+LYoSDnYBdQqmMt6+UzjpkKa0=";
        };
      });
    };
  };
}
