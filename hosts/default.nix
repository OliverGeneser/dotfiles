{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;

    homeImports = import "${self}/home/profiles";

    mod = "${self}/system";
    # get the basic config to build on top of
    inherit (import mod) laptop desktop server;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    enterprise = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ [
          ./enterprise
          #"${mod}/core/lanzaboote.nix"

          "${mod}/programs/gamemode.nix"
          "${mod}/programs/hyprland"
          "${mod}/programs/games.nix"

          "${mod}/network/spotify.nix"
          "${mod}/network/syncthing.nix"

          "${mod}/services/vpn.nix"
          "${mod}/services/postgres.nix"
          "${mod}/services/gnome-services.nix"
          "${mod}/services/location.nix"

          {
            home-manager = {
              users.olivergeneser.imports = homeImports."olivergeneser@enterprise";
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }

          inputs.chaotic.nixosModules.default
        ];
    };

    apollo = nixosSystem {
      inherit specialArgs;
      modules =
        laptop
        ++ [
          ./apollo
          #"${mod}/core/lanzaboote.nix"

          "${mod}/programs/gamemode.nix"
          "${mod}/programs/hyprland"

          "${mod}/network/spotify.nix"
          "${mod}/network/syncthing.nix"

          "${mod}/services/vpn.nix"
          "${mod}/services/postgres.nix"
          "${mod}/services/gnome-services.nix"
          "${mod}/services/location.nix"

          {
            home-manager = {
              users.olivergeneser.imports = homeImports."olivergeneser@apollo";
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }

          inputs.chaotic.nixosModules.default
        ];
    };

    thor = nixosSystem {
      inherit specialArgs;
      modules =
        server
        ++ [
          ./thor
          #"${mod}/core/lanzaboote.nix"

          "${mod}/network/syncthing.nix"

          "${mod}/services/vpn.nix"
          "${mod}/services/postgres.nix"
          "${mod}/services/syncthing.nix"
          "${mod}/services/gnome-services.nix"
          "${mod}/services/location.nix"

          {
            home-manager = {
              users.nixos.imports = homeImports.server;
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }
        ];
    };
  };
}
