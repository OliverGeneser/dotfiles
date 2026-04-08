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
              pkgs.prettier
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

          pythonCDS = let
            inherit (pkgs) lib;
          in
            pkgs.mkShell {
              name = "pythonUV";
              packages = with pkgs; [
                # Python
                python3

                # Build tools
                gcc
                pkg-config

                # Required system libs for uwsgi + common python C extensions
                stdenv.cc.cc.lib
                libxcrypt
                openssl
                zlib
                libffi

                # PDF
                qpdf

                # SVG / formatter stack
                cairo
                pango
                gdk-pixbuf
                libxml2
                libxslt

                # Your tools
                pipenv
                uv
              ];

              # Makes sure linker finds libs
              LD_LIBRARY_PATH = lib.makeLibraryPath [
                pkgs.stdenv.cc.cc.lib
                pkgs.libxcrypt
                pkgs.openssl
                pkgs.zlib
                pkgs.libffi
                pkgs.qpdf
                pkgs.cairo
                pkgs.pango
                pkgs.gdk-pixbuf
                pkgs.libxml2
                pkgs.libxslt
              ];
            };

          python311 = let
            inherit (pkgs) lib;
            python = pkgs.python311;

            pythonldlibpath = lib.makeLibraryPath (with pkgs; [
              cairo
              zlib
              zstd
              stdenv.cc.cc
              curl
              openssl
              attr
              libssh
              bzip2
              libxml2
              libxcrypt
              acl
              libsodium
              util-linux
              xz
              systemd
            ]);

            patchedpython = python.overrideAttrs (
              previousAttrs: {
                # Add the nix-ld libraries to the LD_LIBRARY_PATH.
                # creating a new library path from all desired libraries
                postInstall =
                  previousAttrs.postInstall
                  + ''
                    mv  "$out/bin/python3.11" "$out/bin/unpatched_python3.11"
                    cat << EOF >> "$out/bin/python3.11"
                    #!/run/current-system/sw/bin/bash
                    export LD_LIBRARY_PATH="${pythonldlibpath}"
                    exec "$out/bin/unpatched_python3.11" "\$@"
                    EOF
                    chmod +x "$out/bin/python3.11"
                  '';
              }
            );

            patcheduv = pkgs.uv.overrideAttrs (
              previousAttrs: {
                buildInputs = (previousAttrs.buildInputs or []) ++ [pkgs.makeWrapper];
                postInstall =
                  previousAttrs.postInstall
                  + ''
                    wrapProgram $out/bin/uv \
                      --prefix LD_LIBRARY_PATH : "${pythonldlibpath}"
                  '';
              }
            );
          in
            pkgs.mkShell {
              packages = with pkgs; [
                patchedpython
                python311Packages.setuptools
                python311Packages.wheel
                pipenv
                libxcrypt

                patcheduv
                nodejs
                yarn
              ];
              shellHook = ''
                export NODE_PATH=$(npm root -g)
              '';
              name = "python";
            };

          pythonCERN = let
            inherit (pkgs) python3Packages fetchFromGitHub lib;
            py = python3Packages;
            pynpm = py.buildPythonPackage rec {
              pname = "pynpm";
              version = "0.3.0";
              pyproject = true;
              build-system = with py; [setuptools babel];
              src = py.fetchPypi {
                inherit version;
                pname = "pynpm";
                hash = "sha256-pp/KrDPoUh6neUhMp41g44BGsYoPMp2c2WhI4+CVLSY=";
              };

              propagatedBuildInputs = with py; [setuptools babel];
              doCheck = false;
            };

            pipfile = py.buildPythonPackage rec {
              pname = "pipfile";
              version = "0.0.2";
              format = "setuptools";
              src = py.fetchPypi {
                inherit version;
                pname = "pipfile";
                hash = "sha256-99nxXei2YJhlV+s8xTkaoaFiB6xBvDeNA/QUdi02yYQ=";
              };
              propagatedBuildInputs = with py; [setuptools toml];
              doCheck = false;
            };

            pipenv = py.buildPythonPackage rec {
              pname = "pipenv";
              version = "2026.0.3";
              pyproject = true;
              build-system = with py; [setuptools];
              src = py.fetchPypi {
                inherit version;
                pname = "pipenv";
                hash = "sha256-mjnROkHtjkNorVBiCUEZHzVzGcj/t99Fh1x8XcZgT/Y=";
              };
              propagatedBuildInputs = with py; [setuptools certifi virtualenv];
              doCheck = false;
            };

            invenio-cli = py.buildPythonApplication rec {
              pname = "invenio-cli";
              version = "1.9.2";
              pyproject = true;
              build-system = with py; [setuptools wheel babel];
              src = py.fetchPypi {
                inherit version;
                pname = "invenio_cli";
                hash = "sha256-iLbnJ36KbXjZtU7YRAVnQINViIdWfSRnpKqUkuxBJLI=";
              };
              propagatedBuildInputs = with py; [
                babel
                cookiecutter
                click
                click-default-group
                docker
                pipfile
                pipenv
                pyyaml
                pynpm
                virtualenv
                tomli

                libxslt
                libxml2
              ];
            };
          in
            pkgs.mkShell {
              packages = with pkgs; [
                uv
                cairo
                pipenv
                libxcrypt
                invenio-cli

                (pkgs.python3.withPackages (
                  python-pkgs: [
                    python-pkgs.pycairo
                    python-pkgs.pandas
                    python-pkgs.requests
                    python-pkgs.matplotlib

                    python-pkgs.lxml
                  ]
                ))
              ];
              name = "python";
              shellHook = ''
                                export PIP_NO_BUILD_ISOLATION=1
                export PIP_DISABLE_PIP_VERSION_CHECK=1
                              export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
                  pkgs.libxml2
                  pkgs.libxslt
                  pkgs.cairo
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
      inputs = {
        systems.follows = "systems";
      };
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

    anyrun = {
      url = "github:fufexan/anyrun/launch-prefix";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
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

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      inputs.nixpkgs.follows = "nixpkgs";
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

    wezterm = {
      url = "github:wez/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
