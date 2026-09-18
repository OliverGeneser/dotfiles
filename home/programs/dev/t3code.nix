{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    inputs.t3-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.nightly
  ];
}
