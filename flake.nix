{
  description = "";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";


    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Custom
    impermanence.url = "github:nix-community/impermanence";
    persist-retro.url = "github:Geometer1729/persist-retro";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    neovim = {
      url = "github:IogaMaster/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:IogaMaster/nix-colors";

    # Desktop - Hyprland
    # hypr-contrib.url = "github:hyprwm/contrib";
    # hypridle.url = "github:hyprwm/Hypridle";
    # hyprlock.url = "github:hyprwm/Hyprlock";
    # hyprpaper.url = "github:hyprwm/hyprpaper";

    # hyprland-git.url = "github:hyprwm/hyprland";
    # hyprland-xdph-git.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    # hyprland-protocols-git.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    # hyprland-nix.url = "github:spikespaz/hyprland-nix";
    # hyprland-nix.inputs = {
    #   hyprland.follows = "hyprland-git";
    #   hyprland-xdph.follows = "hyprland-xdph-git";
    #   hyprland-protocols.follows = "hyprland-protocols-git";
    # };

    # Terminal
    wezterm = {
      url = "github:wez/wezterm?dir=nix";
    };
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;

      snowfall = {
        meta = {
          name = "dotfiles";
          title = "dotfiles";
        };

        namespace = "custom";
      };
    };
  in
    lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config = {
        allowUnfree = true;
      };

      overlays = with inputs; [
        neovim.overlays.x86_64-linux.neovim
      ];

      systems.modules.nixos = with inputs; [
        disko.nixosModules.disko
        impermanence.nixosModules.impermanence
        persist-retro.nixosModules.persist-retro
        {
          # Required for impermanence
          fileSystems."/persist".neededForBoot = true;
        }
      ];

      templates = import ./templates {};
    };
}
