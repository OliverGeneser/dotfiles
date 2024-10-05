{ config
, lib
, ...
}:
with lib;
with lib.custom; let
  cfg = config.hardware.networking;
in
{
  options.hardware.networking = with types; {
    enable = mkBoolOpt false "Enable networkmanager";
    allowedTCPPorts = mkOpt (listOf int) [ ] "Allowed TCP ports.";
    allowedUDPPorts = mkOpt (listOf int) [ ] "Allowed UDP ports.";
    allowedTCPPortRanges = mkOpt (listOf (attrsOf int)) [ ] "Allowed TCP port ranges.";
    allowedUDPPortRanges = mkOpt (listOf (attrsOf int)) [ ] "Allowed UDP port ranges.";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ ] ++ cfg.allowedTCPPorts;
      allowedUDPPorts = [ ] ++ cfg.allowedUDPPorts;
      allowedTCPPortRanges = [ ] ++ cfg.allowedTCPPortRanges;
      allowedUDPPortRanges = [ ] ++ cfg.allowedUDPPortRanges;
    };
    networking.networkmanager.enable = true;
  };
}
