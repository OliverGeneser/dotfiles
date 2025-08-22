{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [webcord opencode];

    opencode = self: super: {
      opencode = super.opencode.overrideAttrs (final: prev: {
        version = "0.5.13";

        src = prev.src.override {
          tag = "v${final.version}";
          hash = "sha256-CzVzBvuK/RRYxFA4wOhkIXuXjoxWHHRnzUpGuvl9kQU=";
        };

        node_modules = prev.node_modules.overrideAttrs (_: {
          outputHash = "sha256-hznCg/7c9uNV7NXTkb6wtn3EhJDkGI7yZmSIA2SqX7g=";
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
