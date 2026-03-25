{
  inputs,
  pkgs,
  self,
  ...
}: {
  programs.k9s = {
    enable = true;
  };
}
