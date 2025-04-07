{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [webcord gamemode];

    webcord = _: prev: {
      webcord = prev.webcord.override {
        electron = prev.electron_32;
      };
    };

    gamemode = _: prev: {
      gamemode = prev.gamemode.overrideAttrs (oldAttrs: {
        src = prev.fetchFromGitHub {
          owner = "FeralInteractive";
          repo = "gamemode";
          tag = "1.8.2";
          hash = "sha256-V0rewbSVOGFqJqXyCz4jXpuDM0EfjdkpGPl+WdDwI5I=";
        };
      });
    };
  };
}
