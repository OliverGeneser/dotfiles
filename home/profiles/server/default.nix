{
  self,
  config,
  ...
}: {
  imports = [
    # editors
    ../../editors/nvim

    # terminal emulators
    ../../terminal/emulators/wezterm
  ];
  config = {
    home = {
      username = "nixos";
      homeDirectory = "/home/nixos";
      stateVersion = "23.11";
    };
  };
}
