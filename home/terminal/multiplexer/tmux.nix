{
  pkgs,
  self,
  ...
}: {
  home.packages = [
    self.packages.${pkgs.stdenv.hostPlatform.system}.tmux-sessionizer
  ];

  xdg.configFile = {
    "tmux-sessionizer/tmux-sessionizer.conf".text = ''
      TS_EXTRA_SEARCH_PATHS=(~/dev:2)
    '';
  };

  programs.tmux = {
    enable = true;

    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    focusEvents = true;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";
    terminal = "tmux-256color";

    extraConfig = ''
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      bind-key -r C-f run-shell "tmux neww ${self.packages.${pkgs.stdenv.hostPlatform.system}.tmux-sessionizer}/bin/tmux-sessionizer"
      bind-key -r M-j run-shell "tmux neww ${self.packages.${pkgs.stdenv.hostPlatform.system}.tmux-sessionizer}/bin/tmux-sessionizer -s 0"
      bind-key -r M-k run-shell "tmux neww ${self.packages.${pkgs.stdenv.hostPlatform.system}.tmux-sessionizer}/bin/tmux-sessionizer -s 1"
      bind-key -r M-l run-shell "tmux neww ${self.packages.${pkgs.stdenv.hostPlatform.system}.tmux-sessionizer}/bin/tmux-sessionizer -s 2"
    '';

    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-save 'S'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];
  };
}
