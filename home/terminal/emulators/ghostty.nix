{
  inputs,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    package =
      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      window-decoration = true;
      window-padding-x = 8;
      window-padding-y = 8;
      keybind = [
        "ctrl+h=goto_split:left"
        "ctrl+l=goto_split:right"
      ];
    };
  };
}
