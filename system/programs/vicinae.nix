{ inputs, ... }:
{
  imports = [
    inputs.vicinae.nixosModules.default
  ];

  programs.vicinae.input-server.enable = true;
}
