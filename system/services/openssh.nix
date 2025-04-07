{
  config,
  lib,
  ...
}: {
  services.openssh = {
    enable = true;
    ports = [22];

    allowSFTP = true;

    settings = {
      UseDns = true;
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
      PermitRootLogin = "no";
      StreamLocalBindUnlink = "yes";
      GatewayPorts = "clientspecified";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [22];
    allowedUDPPorts = [22];
  };

  users.users = {
    ${config.custom.user.name}.openssh.authorizedKeys.keys = [
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBGC3EOmZkrcXn3E9+xUAVxWsgWIDjPDFn6HPt/IAzkWnGa00XtfkcuLijMohxny+Lw/U8gIPs67vqSC8tR2ITowAAAAEc3NoOg== hello@geneser.xyz"
    ];
  };
}
