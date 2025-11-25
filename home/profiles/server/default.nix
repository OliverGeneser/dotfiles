{
  self,
  config,
  ...
}: {
  imports = [
    # editors
    ../../editors/nvim

    # terminal
    ../../terminal/programs/bat.nix
    ../../terminal/programs/cli.nix
    ../../terminal/programs/git.nix
    ../../terminal/programs/htop.nix
    ../../terminal/programs/nix.nix
    ../../terminal/programs/podman.nix
    ../../terminal/programs/skim.nix
    ../../terminal/programs/ssh.nix
    ../../terminal/programs/yazi
    ../../terminal/programs/xdg.nix

    # terminal emulators
    ../../terminal/emulators/ghostty.nix

    # terminal multiplexers
    ../../terminal/multiplexer/tmux.nix
  ];
  config = {
    home = {
      username = "nixos";
      homeDirectory = "/home/nixos";
      stateVersion = "23.11";
    };
  };
}
