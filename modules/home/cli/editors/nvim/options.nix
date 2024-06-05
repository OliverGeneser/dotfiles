{config, ...}: {
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = ",";

      netrw_browse_split = 0;
      netrw_banner = 0;
      netrw_winsize = 25;
    };

    opts = {
      nu = true;
      relativenumber = true;

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;

      smartindent = true;

      wrap = false;

      swapfile = false;
      backup = false;
      undodir = "/home/${config.custom.user.name}/.vim/undodir";
      undofile = true;

      hlsearch = false;
      incsearch = true;

      termguicolors = true;

      scrolloff = 8;
      signcolumn = "yes";

      updatetime = 50;

      colorcolumn = "80";
    };
  };
}
