{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.browsers.firefox;
in {
  options.browsers.firefox = with types; {
    enable = mkBoolOpt false "Enable or disable firefox browser";
  };

  imports = with inputs; [
    arkenfox.hmModules.default
  ];

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      arkenfox = {
        enable = true;
        version = "122.0";
      };
      profiles.Default = {
        isDefault = true;
        #        settings = {
        #         "dom.security.https_only_mode" = true;
        #        "browser.download.panel.shown" = true;
        #       "identity.fxaccounts.enabled" = false;
        #      "signon.rememberSignons" = false;
        #   };
        extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
          ublock-origin
          bitwarden
          vimium
          user-agent-string-switcher
        ];
        search.default = "DuckDuckGo";
        search.engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
        };
        arkenfox = {
          enable = true;
          "0000".enable = true;
          "0100" = {
            enable = true;
          };
          "0200" = {
            enable = true;
          };
          "0300" = {
            enable = true;
          };
          "0400" = {
            enable = true;
          };
          "0600" = {
            enable = true;
          };
          "0700" = {
            enable = true;
          };
          "0800" = {
            enable = true;
          };
          "0900" = {
            enable = true;
          };
          "1000" = {
            enable = true;
          };
          "1200" = {
            enable = true;
          };
          "1600" = {
            enable = true;
          };
          "1700" = {
            enable = true;
          };
          "2000" = {
            enable = true;
          };
          "2400" = {
            enable = true;
          };
          "2600" = {
            enable = true;
          };
          "2700" = {
            enable = true;
          };
          "2800" = {
            enable = true;
          };
          "4000" = {
            enable = true;
          };
          "4500" = {
            enable = true;
          };
          "5000" = {
            enable = true;
          };
          "5500" = {
            enable = true;
          };
          "6000" = {
            enable = true;
          };
          "7000" = {
            enable = true;
          };
          "8000" = {
            enable = true;
          };
          "9000" = {
            enable = true;
          };
        };
      };
    };
  };
}
