{
  pkgs,
  inputs,
  ...
}:
  pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";

    packages = with pkgs; [
      statix
      deadnix
      alejandra
      home-manager
      git
      sops
      ssh-to-age
      gnupg
      age
    ];
  }
