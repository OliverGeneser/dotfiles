{
  config,
  lib,
  ...
}:
{
  sops.secrets.searx_env = {
    sopsFile = ./secrets.yaml;
  };

  services.searx = {
    enable = true;
    redisCreateLocally = true;
    environmentFile = config.sops.secrets.searx_env.path;
  };
}
