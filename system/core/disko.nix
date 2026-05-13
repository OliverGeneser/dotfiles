{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];
}
