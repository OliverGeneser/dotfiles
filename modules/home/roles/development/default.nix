{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.roles.development;
in {
  options.roles.development = {
    enable = mkEnableOption "Enable development configuration";
  };

  config = mkIf cfg.enable {
    programs = {
      #arduino.enable = true;
      beekeeperStudio.enable = true;
      #httpie.enable = true;
    };

    cli = {
      programs = {
        act.enable = true;
        aws.enable = true;
        bat.enable = true;
        bottom.enable = true;
        direnv.enable = true;
        eza.enable = true;
        fzf.enable = true;
        git.enable = true;
        gpg.enable = true;
        htop.enable = true;
        k8s.enable = true;
        modern-unix.enable = true;
        network-tools.enable = true;
        nix-index.enable = true;
        podman.enable = true;
        sqlite.enable = true;
        ssh.enable = true;
        starship.enable = true;
        yazi.enable = true;
        zoxide.enable = true;

        nodejs.enable = true;
        bun.enable = true;
        python.enable = true;
      };
    };
  };
}
