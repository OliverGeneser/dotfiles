{
  pkgs,
  config,
  ...
}:
{
  imports = [ ../../terminal/programs/python.nix ];

  config = {
    stylix.targets.neovim.enable = false;

    home.packages = with pkgs; [
      ripgrep
      fd
      gcc
      icu
      gnumake
      alejandra
      prettier
      prettierd
      # black
      blade-formatter
    ];

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;

      withRuby = false;
      withPython3 = false;

      initLua = ''
        require("config.lazy")
      '';
    };

    xdg.configFile."nvim/lua".source =
      config.lib.file.mkOutOfStoreSymlink "/home/${config.home.username}/dotfiles/home/editors/nvim/lua";
  };
}
