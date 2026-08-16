{
  config,
  lib,
  ...
}:
{
  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];

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

    fail2ban = {
      enable = true;

      ignoreIP = [
        "127.0.0.1/8"
        "::1"

        # Your Tailscale devices
        "100.120.223.24" # thor
        "100.101.50.22" # ariane
        "100.125.40.82" # enterprise-1
        "100.70.227.58" # pixel-10-pro
        "100.78.211.15" # living-room-tv
        "100.94.64.22" # pixel-10-pro-xl
        "100.80.169.74" # pixel-10
      ];
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ 22 ];
  };

  users.users = {
    ${config.custom.user.name}.openssh.authorizedKeys.keys = [
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBGC3EOmZkrcXn3E9+xUAVxWsgWIDjPDFn6HPt/IAzkWnGa00XtfkcuLijMohxny+Lw/U8gIPs67vqSC8tR2ITowAAAAEc3NoOg== hello@geneser.xyz"
    ];
  };
}
