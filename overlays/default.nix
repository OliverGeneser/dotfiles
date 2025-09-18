{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [beekeeper-studio bun opencode turso-cli webcord];

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (final: prev: {
        version = "5.3.6";

        src = super.fetchurl {
          url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
          hash = "sha256-W1yyKX333vRkcsG46KVCrFp/Zg4ryMvn6/Ns5CYRE6k=";
        };
      });
    };

    bun = self: super: {
      bun = super.bun.overrideAttrs (final: prev: {
        version = "1.2.22";

        src = super.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v1.2.22/bun-linux-x64.zip";
          hash = "sha256-TERq8aAde0Dh4RuuvDUvmyv9Eoh+Ubl907WYec7idDo=";
        };
      });
    };

    opencode = self: super: {
      opencode = super.opencode.overrideAttrs (final: prev: {
        version = "0.9.11";

        src = prev.src.override {
          tag = "v${final.version}";
          hash = "sha256-L8cGRrm5cui7J5sjFqNFStgqRDQIota5AgvMMm/1o7c=";
        };

        tui = prev.tui.overrideAttrs (_: {
          vendorHash = "sha256-H+TybeyyHTbhvTye0PCDcsWkcN8M34EJ2ddxyXEJkZI=";
        });

        node_modules = prev.node_modules.overrideAttrs (_: {
          outputHash = "sha256-fGf2VldMlxbr9pb3B6zVL+fW1S8bRjefJW+jliTO73A=";
          buildPhase = ''
            runHook preBuild

             export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

             # Disable post-install scripts to avoid shebang issues
             bun install \
               --filter=opencode \
               --force \
               --ignore-scripts \
               --no-progress
               # Remove `--frozen-lockfile` and `--production` — they erroneously report the lockfile needs updating even though `bun install` does not change it.
               # Related to  https://github.com/oven-sh/bun/issues/19088
               # --frozen-lockfile \
               # --production

            runHook postBuild
          '';
        });
        buildPhase = ''
          runHook preBuild

          bun build \
            --define OPENCODE_TUI_PATH="'${final.tui}/bin/tui'" \
            --define OPENCODE_VERSION="'${final.version}'" \
            --compile \
            --target=bun-linux-x64 \
            --outfile=opencode \
            ./packages/opencode/src/index.ts \

          runHook postBuild
        '';
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

    webcord = _: prev: {
      webcord = prev.webcord.override {
        electron = prev.electron_32;
      };
    };
  };
}
