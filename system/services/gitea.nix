{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.gitea = {
    enable = true;
    appName = "Geneser Home Gitea server"; # Give the site a name
    lfs.enable = true;

    settings = {
      server = {
        ROOT_URL = "https://git.thor.geneser.dev/";
        HTTP_PORT = 4500;
      };
    };
  };
}
