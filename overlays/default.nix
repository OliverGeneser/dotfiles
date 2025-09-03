{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [webcord opencode];

    opencode = self: super: {
      opencode = super.opencode.overrideAttrs (final: prev: {
        version = "0.6.4";

        src = prev.src.override {
          tag = "v${final.version}";
          hash = "sha256-o7SzDGbWgCh8cMNK+PeLxAw0bQMKFouHdedUslpA6gw=";
        };

        tui = prev.tui.overrideAttrs (_: {
          vendorHash = "sha256-8pwVQVraLSE1DRL6IFMlQ/y8HQ8464N/QwAS8Faloq4=";
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
