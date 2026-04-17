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
      TS_EXTRA_SEARCH_PATHS=(~/dev:3)
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
      set -ga terminal-overrides ",*:Tc"

      set -g status-right '#[fg=black]#{cpu_bg_color} CPU: #{cpu_icon} #{cpu_percentage} | %a %h-%d %H:%M '
      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux

      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      bind -r D neww -c "#{pane_current_path}" "[[ -e TODO.md ]] && nvim TODO.md || nvim ~/dev/todo.md"

      bind-key -r f run-shell "tmux neww tmux-sessionizer"
      bind-key -r M-j run-shell "tmux neww tmux-sessionizer -s 0"
      bind-key -r M-k run-shell "tmux neww tmux-sessionizer -s 1"
      bind-key -r M-l run-shell "tmux neww tmux-sessionizer -s 2"
    '';

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
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
