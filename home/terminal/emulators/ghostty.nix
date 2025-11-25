{
  inputs,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package =
      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      window-padding-x = 8;
      window-padding-y = 8;
      cursor-style = "block";
      cursor-style-blink = true;

      shell-integration-features = "no-cursor,no-sudo,no-title";
      gtk-titlebar = false;
      keybind = [
        "ctrl+enter=unbind"
      ];

      command = "tmux";
    };
  };
}
