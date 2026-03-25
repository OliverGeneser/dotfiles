{pkgs, ...}: {
  security.krb5 = {
    enable = true;

    settings = {
      domain_realm = {
        ".cern.ch" = "CERN.CH";
        ".aiadm.cern.ch" = "CERN.CH";
      };

      realms = {
        "CERN.CH" = {
          default_domain = "cern.ch";
          kdc = ["cerndc.cern.ch"];
        };
      };

      libdefaults = {
        default_realm = "CERN.CH";

        ticket_lifetime = "25h";
        renew_lifetime = "120h";
        forwardable = "true";
        proxiable = "true";
      };
    };
  };
}
