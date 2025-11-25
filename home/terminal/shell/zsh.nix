{
  config,
  lib,
  self,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      expireDuplicatesFirst = true;
      path = "${config.xdg.dataHome}/zsh_history";
    };

    initContent = ''
      bindkey -s ^f "${self.packages.${pkgs.stdenv.hostPlatform.system}.tmux-sessionizer}/bin/tmux-sessionizer\n"

      # search history based on what's typed in the prompt
      autoload -U history-search-end
      zle -N history-beginning-search-backward-end history-search-end
      zle -N history-beginning-search-forward-end history-search-end
      bindkey "^[OA" history-beginning-search-backward-end
      bindkey "^[OB" history-beginning-search-forward-end

      # open commands in $EDITOR with C-e
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^e" edit-command-line

      # case insensitive tab completion
      zstyle ':completion:*' completer _complete _ignored _approximate
      zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
      zstyle ':completion:*' verbose true

      # use cache for completions
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
      _comp_options+=(globdots)
    '';

    shellAliases =
      {
        cd = "z";
        cdi = "zi";
        cp = "xcp";
        grep = "rg";
        ip = "ip --color";
        ls = "eza";
        sl = "eza";
        l = "eza --group --header --group-directories-first --long --git --all --binary --all --icons always";
        la = "eza -la";
        md = "mkdir -p";
        ppc = "powerprofilesctl";
        pf = "powerprofilesctl launch -p performance";
        tree = "eza --tree";
        sudo = "sudo -E -s";
        curl = "curlie";
        rm = "trash";
        ping = "gping";

        weather = "curl wttr.in/Copenhagen";

        us = "systemctl --user"; # mnemonic for user systemctl
        rs = "sudo systemctl"; # mnemonic for root systemctl

        docker = "podman";
        docker-compose = "podman-compose";

        # laptop
        battery = "set batteryCharge (bat /sys/class/power_supply/BAT0/capacity) && set batteryStatus (bat /sys/class/power_supply/BAT0/status); echo -e \"Charge: $batteryCharge% \nCurrently: $batteryStatus\"";

        husky = ": > /dev/null";
      }
      // lib.optionalAttrs config.programs.bat.enable {cat = "bat";};
    shellGlobalAliases = {eza = "eza --icons --git";};
  };
}
