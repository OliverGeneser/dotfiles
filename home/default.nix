{
  self,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./terminal
    inputs.nix-index-db.hmModules.nix-index
    inputs.tailray.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
    inputs.stylix.homeManagerModules.stylix
    inputs.catppuccin.homeModules.catppuccin
  ];

  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  sops = {
    age = {
      generateKey = true;
      keyFile = "/home/${config.home.username}/.config/sops/age/keys.txt";
      sshKeyPaths = ["/home/${config.home.username}/.ssh/id_ed25519"];
    };

    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.packages = with pkgs; [
    nix-output-monitor
    nvd
    nix-init
  ];

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    image = self.packages.${pkgs.system}.wallpapers.gfda_40-black_5120x2880;

    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    fonts = {
      sizes = {
        terminal = 14;
        applications = 12;
        popups = 12;
      };

      serif = {
        name = "Source Serif";
        package = pkgs.source-serif;
      };

      sansSerif = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
      };

      monospace = {
        package = pkgs.nerd-fonts.fira-mono;
        name = "FiraMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
