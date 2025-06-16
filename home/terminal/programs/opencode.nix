{
  pkgs,
  self,
  ...
}: {
  home.packages = with pkgs; [
    opencode
  ];
}
