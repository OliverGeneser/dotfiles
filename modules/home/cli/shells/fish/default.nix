{ pkgs
, lib
, config
, host
, ...
}:
with lib;
with lib.custom; let
  cfg = config.cli.shells.fish;
in
{
  options.cli.shells.fish = with types; {
    enable = mkBoolOpt false "enable fish shell";
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      catppuccin.enable = true;
      interactiveShellInit = ''
        # Open command buffer in vim when alt+e is pressed
        bind \ee edit_command_buffer
        ${pkgs.nix-your-shell}/bin/nix-your-shell --nom fish | source
        fish_add_path --path --prepend /usr/local/bin /usr/bin ~/.local/bin
        set -x GOPATH $XDG_DATA_HOME/go
        set -x GOPRIVATE "git.curve.tools,gitlab.com/imaginecurve"
        set -gx PATH /usr/local/bin /usr/bin ~/.local/bin $GOPATH/bin/ $PATH $HOME/.krew/bin
        # fish_add_path --path --append $GOPATH/bin/
        # fish_add_path --path --append /usr/local/bin /usr/bin ~/.local/bin

        # fifc setup
        set -Ux fifc_editor nvim
        set -U fifc_keybinding \cx
        bind \cx _fifc
        bind -M insert \cx _fifc

        fish_vi_key_bindings
        set fish_cursor_default     block      blink
        set fish_cursor_insert      line       blink
        set fish_cursor_replace_one underscore blink
        set fish_cursor_visual      block

        set -Ux HUSKEY 0
      '';
      shellAliases = {
        wget = "wget --hsts-file=\"$XDG_DATA_HOME/wget-hsts\"";

        # Fuck husky
        husky = "echo \"Husky is disabled on this system.\"";
      };
      shellAbbrs = {
        # abbr existing commands
        vim = "nvim";
        n = "nvim";
        cd = "z";
        cdi = "zi";
        cp = "xcp";
        grep = "rg";
        dig = "dog";
        cat = "bat";
        curl = "curlie";
        rm = "trash";
        ping = "gping";
        ls = "eza";
        sl = "eza";
        l = "eza --group --header --group-directories-first --long --git --all --binary --all --icons";
        tree = "eza --tree";
        sudo = "sudo -E -s";

        # nix
        nhh = "nh home switch";
        nho = "nh os switch";
        nhu = "nh os switch --update --ask";
        nht = "nh os test";

        nd = "nix develop";
        nfu = "nix flake update";
        hms = "home-manager switch --flake ~/dotfiles#${config.custom.user.name}@${host}";
        hmr = "home-manager generations | fzf --tac --no-sort | awk '{print $7}' | xargs -I{} bash {}/activate";
        nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#${host}";
        nrt = "sudo nixos-rebuild test --flake ~/dotfiles#${host}";

        resof = "sudo filefrag -v /swap/swapfile | awk '$1==\"0:\" {print substr($4, 1, length($4)-2)}'";

        # new commads
        weather = "curl wttr.in/Copenhagen";

        pfile = "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'";
        gdub = "git fetch -p && git branch -vv | grep ': gone]' | awk '{print }' | xargs git branch -D $argv;";
        tldrf = "tldr --list | fzf --preview \"tldr {1} --color=always\" --preview-window=right,70% | xargs tldr";
        dk = "docker kill (docker ps -q)";
        ds = "docker stop (docker ps -a -q)";
        drm = "docker rm (docker ps -a -q)";
        docker-compose = "podman-compose";

        # laptop
        battery = "set batteryCharge (bat /sys/class/power_supply/BAT0/capacity) && set batteryStatus (bat /sys/class/power_supply/BAT0/status); echo -e \"Charge: $batteryCharge% \nCurrently: $batteryStatus\"";

        # git
        gmt = "git merge template/main --allow-unrelated-histories";

        # Fuck husky
        husky = "echo \"Husky is disabled on this system.\"";
      };

      functions = {
        fish_greeting = '''';

        envsource = ''
          for line in (cat $argv | grep -v '^#')
            set item (string split -m 1 '=' $line)
            set -gx $item[1] $item[2]
            echo "Exported key $item[1]"
          end
        '';

        fish_command_not_found = ''
          # If you run the command with comma, running the same command
          # will not prompt for confirmation for the rest of the session
          if contains $argv[1] $__command_not_found_confirmed_commands
            or ${pkgs.gum}/bin/gum confirm --selected.background=2 "Run using comma?"

            # Not bothering with capturing the status of the command, just run it again
            if not contains $argv[1] $__command_not_found_confirmed_commands
              set -ga __fish_run_with_comma_commands $argv[1]
            end

            comma -- $argv
            return 0
          else
            __fish_default_command_not_found_handler $argv
          end
        '';
      };
      plugins = [
        {
          name = "bass";
          inherit (pkgs.fishPlugins.bass) src;
        }
        {
          name = "fzf-fish";
          inherit (pkgs.fishPlugins.fzf-fish) src;
        }
        {
          name = "fifc";
          inherit (pkgs.fishPlugins.fifc) src;
        }
        {
          name = "git-abbr";
          inherit (pkgs.fishPlugins.git-abbr) src;
        }
      ];
    };
  };
}
