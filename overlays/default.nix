{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [webcord opencode turso-cli beekeeper-studio];

    opencode = self: super: {
      opencode = super.opencode.overrideAttrs (final: prev: {
        version = "0.7.1";

        src = prev.src.override {
          tag = "v${final.version}";
          hash = "sha256-RU4Qq2xGPOdK/GxHAcAaJYrx31ZhZ/fFuOmvyqqr538=";
        };

        tui = prev.tui.overrideAttrs (_: {
          vendorHash = "sha256-u7jomV6lzr5QMICJ20ED6oAe7euXjsRUjuPl/YiTBfk=";
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

    beekeeper-studio = self: super: {
      beekeeper-studio = super.beekeeper-studio.overrideAttrs (final: prev: {
        version = "5.3.6";

        src = super.fetchurl {
          url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${final.version}/beekeeper-studio_${final.version}_amd64.deb";
          hash = "sha256-W1yyKX333vRkcsG46KVCrFp/Zg4ryMvn6/Ns5CYRE6k=";
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
