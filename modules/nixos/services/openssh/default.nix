{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.custom.ssh;
in {
  options.services.custom.ssh = with types; {
    enable = mkBoolOpt false "Enable ssh";
    authorizedKeys = mkOpt (listOf str) [] "The public keys to apply.";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [1337];

      settings = {
        PasswordAuthentication = false;
        PubkeyAuthentication = true;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        GatewayPorts = "clientspecified";
      };
    };
    users.users = {
      ${config.user.name}.openssh.authorizedKeys.keys = [
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBGC3EOmZkrcXn3E9+xUAVxWsgWIDjPDFn6HPt/IAzkWnGa00XtfkcuLijMohxny+Lw/U8gIPs67vqSC8tR2ITowAAAAEc3NoOg== hello@geneser.xyz"
      ];
    };
  };
}
