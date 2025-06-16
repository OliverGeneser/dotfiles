{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [webcord];

    # podman = _: prev: {
    #   podman = prev.podman.overrideAttrs (oldAttrs: {
    #     version = "5.5.0";
    #     src = prev.fetchFromGitHub {
    #       owner = "containers";
    #       repo = "podman";
    #       rev = "v5.5.0";
    #       hash = "sha256-B6n1NybTFhjTMDrhmXS54ZUaLtsmiqLu783bJoDgkyk=";
    #     };
    #   });
    # };

    webcord = _: prev: {
      webcord = prev.webcord.override {
        electron = prev.electron_32;
      };
    };
  };
}
