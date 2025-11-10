{
  inputs,
  withSystemVencord,
  ...
}: {
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
        version = "1.3.2";

        src = super.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v${final.version}/bun-linux-x64.zip";
          hash = "sha256-DLVqRIS9d2Sj7vm55nq0V4QJgSh7RnlJdNHmYSy/Zwk=";
        };
      });
    };

    opencode = self: super: {
      opencode = super.opencode.overrideAttrs (final: prev: {
        version = "1.0.55";
        dontStrip = true;

        src = super.fetchFromGitHub {
          owner = "sst";
          repo = "opencode";
          tag = "v${final.version}";
          hash = "sha256-iKD58BA1ueIVsQXvsAZwXCMkSAM1ZzYPL8WGtKANfIE=";
        };

        postPatch = ''
          # don't require a specifc bun version
          substituteInPlace packages/script/src/index.ts \
            --replace-fail "if (process.versions.bun !== expectedBunVersion)" "if (false)"
        '';
        patches = [
          # NOTE: Patch `packages/opencode/src/provider/models-macro.ts` to get contents of
          # `_api.json` from the file bundled with `bun build`.
          ./local-models-dev.patch
          # NOTE: Skip npm pack commands in build.ts since packages are already in node_modules
          ./skip-npm-pack.patch
        ];

        node_modules = prev.node_modules.overrideAttrs (_: {
          outputHash = "sha256-RIHrhZ2dr3zlyMq4WUSaUdFiVTqNuM87iNZvNizSjKk=";
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
