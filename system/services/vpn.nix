{
  config,
  pkgs,
  ...
}:
{
  networking.wireguard.enable = true;

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  sops.secrets.mullvad_account_id = {
    sopsFile = ./secrets.yaml;
    owner = config.custom.user.name;
  };
}
