{
  pkgs,
  lib,
  config,
  ...
}: {
  services.gitea = {
    enable = true;
    appName = "Geneser Home Gitea server"; # Give the site a name
    #domain = "git.my-domain.tld";
    #rootUrl = "https://git.my-domain.tld/";
    lfs.enable = true;

    settings = {
      server = {
        HTTP_PORT = 4500;
      };
    };
  };
}
