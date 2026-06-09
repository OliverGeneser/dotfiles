{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # misc
    libnotify
    sshfs

    # utils
    curlie
    dust
    duf
    delta
    fd
    file
    jq
    jaq
    ripgrep
    gping

    act

    powertop
    lm_sensors
    plocate

    # trash
    gtrash
    trash-cli

    sd
    xcp

    lsof

    broot
    choose
    chafa
    doggo
    dysk
    entr
    erdtree
    gdu
    gping
    grex
    hyperfine
    hexyl
    jqp
    jnv
    ouch
    procs
    tokei
    plocate
    #tailspin
    yq-go
    viddy

    eas-cli

    # terminal images
    viu
    ueberzugpp

    wget

    ghostscript

    qrencode
  ];

  programs = {
    eza.enable = true;
    fzf = {
      enable = true;
      enableBashIntegration = config.programs.bash.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };

    ssh = {
      enable = true;
    };
  };
}
