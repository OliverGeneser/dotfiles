{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.swaylock;
in {
  options.desktop.addons.swaylock = with types; {
    enable = mkBoolOpt false "Enable or disable swaylock";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      swaylock-effects
    ];

    security.pam.services.swaylock = {};

    home.configFile."swaylock/config" = {
      text = ''
        ignore-empty-password
        font=FiraCode Nerd Font 11

        clock
        timestr=%R
        datestr=%d.%m.%Y

        image=~/.wallpapers/programming-wallpaper.png

        fade-in=0

        #effect-blur=15x2
        #effect-greyscale
        #effect-scale=0.1

        indicator
        indicator-radius=110
        indicator-thickness=10
        indicator-caps-lock

        key-hl-color=194f2b

        separator-color=00000000

        inside-color=01010133
        inside-clear-color=ffd20433
        inside-caps-lock-color=009ddc33
        inside-ver-color=d9d8d833
        inside-wrong-color=ee2e2433

        ring-color=50c878
        ring-clear-color=50c878
        ring-caps-lock-color=50c878
        ring-ver-color=50c878
        ring-wrong-color=50c878

        line-color=00000000
        line-clear-color=ffd204FF
        line-caps-lock-color=009ddcFF
        line-ver-color=d9d8d8FF
        line-wrong-color=ee2e24FF

        text-color=dededeff
        text-clear-color=ffd204ff
        text-ver-color=000000ff
        text-wrong-color=ee2e24ff

        bs-hl-color=ffd204ff
        caps-lock-key-hl-color=ffd204FF
        caps-lock-bs-hl-color=dededeFF
        text-caps-lock-color=009ddcff
      '';
    };
  };
}
