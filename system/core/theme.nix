{
  self,
  config,
  pkgs,
  inputs,
  ...
}: let
  wallpapers = "(${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_34-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_40-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_45-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_63-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_72-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_91-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_155-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_162-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_172-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_189-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_192-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_203-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_205-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_207-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_208-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_210-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_212-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_215-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_230-black_5120x2880} ${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_242-black_5120x2880})";

  wallpaperRandomizer = pkgs.writeShellScriptBin "wallpaperRandomizer" ''
    wallpapers=${wallpapers}
    echo wallpapers
    rand=$[$RANDOM % ''${#wallpapers[@]}]
    wallpaper=''${wallpapers[$rand]}

    monitor=(`hyprctl monitors | grep Monitor | awk '{print $2}'`)
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $wallpaper
    for m in ''${monitor[@]}; do
      hyprctl hyprpaper wallpaper "$m,contain:$wallpaper"
    done
  '';
in {
  imports = [
    inputs.stylix.nixosModules.stylix
    inputs.catppuccin.nixosModules.catppuccin
  ];

  environment.systemPackages = [wallpaperRandomizer];
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages = with pkgs; [
      fira
      fira-go
      noto-fonts-color-emoji
      source-serif
      ubuntu-classic
      open-sans

      # microsoft
      corefonts

      liberation_ttf
      helvetica-neue-lt-std

      # icon fonts
      material-symbols

      # sans serif
      roboto
      (google-fonts.override {fonts = ["Inter"];})

      # monospace
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      nerd-fonts.fira-code

      geist-font
    ];

    fontconfig = {
      antialias = true;
      defaultFonts = {
        serif = ["Source Serif"];
        sansSerif = ["Fira Sans" "FiraGO"];
        monospace = ["FiraMono Nerd Font" "SauceCodePro Nerd Font Mono"];
        emoji = ["Noto Color Emoji"];
      };
      enable = true;
      hinting = {
        autohint = false;
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "light";
      };
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    homeManagerIntegration.autoImport = false;
    homeManagerIntegration.followSystem = false;

    image = self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers.gfda_40-black_5120x2880;

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
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  systemd = {
    services.wallpaperRandomizer = {
      wantedBy = ["graphical-session.target"];

      description = "Set random desktop background using hyprpaper";
      after = ["graphical-session-pre.target" "hyprpaper.service"];
      partOf = ["graphical-session.target"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${wallpaperRandomizer}/bin/wallpaperRandomizer";
        IOSchedulingClass = "idle";
      };
    };

    timers.wallpaperRandomizer = {
      description = "Set random desktop background using hyprpaper on an interval";
      timerConfig = {
        OnUnitActiveSec = "15min";
      };
      wantedBy = ["timers.target"];
    };
  };
}
