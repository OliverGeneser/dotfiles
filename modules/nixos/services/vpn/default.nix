{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.custom.vpn;
in {
  options.services.custom.vpn = {
    enable = mkEnableOption "Enable vpn";
  };

  config = mkIf cfg.enable {
    networking.wireguard.enable = true;
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };

    sops.secrets.mullvad_account_id = {
      sopsFile = ../secrets.yaml;
    };
  };
}
