{ pkgs, ... }: {
  home.packages = with pkgs; [
    awscli2
    s3cmd
  ];
}
