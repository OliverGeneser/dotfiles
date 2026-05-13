{
  self,
  pkgs,
  lib,
  ...
}:
{
  stylix.targets.tofi.enable = lib.mkForce false;
  programs.tofi = {
    enable = true;
    package = pkgs.tofi;
    settings = {
      width = "100%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      num-results = 5;
      font = "${pkgs.nerd-fonts.fira-mono}/share/fonts/opentype/NerdFonts/FiraMono/FiraMonoNerdFontMono-Regular.otf";
      hint-font = false;
      background-color = lib.mkForce "#000A";

      #      background-color = "#000000";
      #     border-width = 0;
      #      font = "monospace";
      #    height = "100%";
      #   num-results = 5;
      #  outline-width = 0;
      # padding-left = "35%";
      #padding-top = "35%";
      # result-spacing = 25;
      # width = "100%";
    };
  };
}
