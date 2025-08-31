{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [webcord opencode];

    opencode = self: super: {
      opencode = super.opencode.overrideAttrs (final: prev: {
        version = "0.5.29";

        src = prev.src.override {
          tag = "v${final.version}";
          hash = "sha256-l9yi+98fsFWERKsJPfhNoCTG9vKawE4aKngwBkCJupE=";
        };

        tui = prev.tui.overrideAttrs (_: {
          vendorHash = "sha256-78MfWF0HSeLFLGDr1Zh74XeyY71zUmmazgG2MnWPucw=";
        });

        node_modules = prev.node_modules.overrideAttrs (_: {
          outputHash = "sha256-PmLO0aU2E7NlQ7WtoiCQzLRw4oKdKxS5JI571lvbhHo=";
        });
      });
    };

    webcord = _: prev: {
      webcord = prev.webcord.override {
        electron = prev.electron_32;
      };
    };
  };
}
