{
  description = "Geneser Config";

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        ./hosts
        ./lib
        ./modules
        ./pkgs
        ./pre-commit-hooks.nix
        ./overlays
      ];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        devShells = {
          default = pkgs.mkShell {
            packages = [
              pkgs.alejandra
              pkgs.git
              pkgs.nodePackages.prettier
              config.packages.repl
              pkgs.nh
              pkgs.disko
              pkgs.sops
              pkgs.ssh-to-age
              pkgs.age
              pkgs.gnupg
              pkgs.home-manager
            ];
            name = "dotfiles";
            DIRENV_LOG_FORMAT = "";
            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };

          node22 = pkgs.mkShell {
            packages = with pkgs; [
              corepack_22
              nodejs_22
              bun
              zip
              libuuid
              gcc
              nodePackages.node-gyp
              python3 # node-gyp needs Python
            ];

            buildInputs = with pkgs; [
              cairo
              giflib
              libjpeg
              libpng
              librsvg
              openssl
              pango
              pixman
              pkg-config
            ];

            env = {
              PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING = 1;
              PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
              PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
              PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
            };

            shellHook = ''
              export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
                pkgs.libuuid
                pkgs.pixman
                pkgs.pkg-config
              ]}:$LD_LIBRARY_PATH"

              echo "Node: $(node --version)"
              echo "Bun: $(bun --version)"
            '';
          };

          python = pkgs.mkShell {
            packages = with pkgs; [
              uv
              cairo
              pipenv
              libxcrypt
              (pkgs.python3.withPackages (
                python-pkgs: [
                  python-pkgs.pycairo
                  python-pkgs.pandas
                  python-pkgs.requests
                  python-pkgs.matplotlib
                ]
              ))
            ];
            name = "python";
            shellHook = ''
              export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
                pkgs.cairo
                pkgs.pkg-config
              ]}:$LD_LIBRARY_PATH"
            '';
          };

          formatter = pkgs.alejandra;
        };
      };
    };

  inputs = {
    # global, so they can be `.follow`ed
    systems.url = "github:nix-systems/default-linux";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # rest
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        systems.follows = "systems";
      };
    };

    anyrun.url = "github:fufexan/anyrun/launch-prefix";

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    custom-udev-rules = {
      url = "github:OliverGeneser/custom-udev-rules";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    lanzaboote.url = "github:nix-community/lanzaboote";

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-anywhere = {
      url = "github:numtide/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode = {
      url = "github:anomalyco/opencode";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };

    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";

      # Optional: Override the nixpkgs input of prismlauncher to use the same revision as the rest of your flake
      # Note that this may break the reproducibility mentioned above, and you might not be able to access the binary cache
      #
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tailray = {
      url = "github:NotAShelf/tailray";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
    };

    wezterm = {
      url = "github:wez/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi.url = "github:sxyazi/yazi";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
