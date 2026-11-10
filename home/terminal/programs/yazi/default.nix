{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # general file info
  home.packages = with pkgs; [
    exiftool
    imagemagick
    ffmpegthumbnailer
    fontpreview
    unar
    poppler
  ];

  # yazi file manager
  programs.yazi = {
    enable = true;

    # Workaround for nixpkgs cargoSetupHook (2026-10) forcing system libs:
    # onig_sys builds with RUSTONIG_SYSTEM_LIBONIG set, so it needs pkg-config
    # + system oniguruma, which the flake's yazi-unwrapped doesn't declare.
    # NOTE: flake packages bypass nixpkgs overlays, so the fix lives here
    # (override wrapper to use the fixed unwrapped) instead of overlays/.
    package =
      let
        yaziPkgs = inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system};
        yaziUnwrappedFixed = yaziPkgs.yazi-unwrapped.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
            pkgs.pkg-config
          ];
          buildInputs = (old.buildInputs or [ ]) ++ [
            pkgs.oniguruma
          ];
        });
      in
      yaziPkgs.yazi.override { yazi-unwrapped = yaziUnwrappedFixed; };

    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;

    shellWrapperName = "y";

    settings = {
      manager = {
        layout = [
          1
          4
          3
        ];
        sort_by = "alphabetical";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = false;
        show_symlink = true;
      };

      preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = config.xdg.cacheHome;
      };
    };
  };
}
