{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  imports = with inputs; [
    arkenfox.hmModules.default
  ];
  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  programs.firefox = {
    enable = true;
    arkenfox = {
      enable = true;
      version = "133.0";
    };
    profiles.oliver = {
      isDefault = true;

      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin

        bitwarden
        vimium
        darkreader
        don-t-fuck-with-paste
        user-agent-string-switcher
      ];

      arkenfox = {
        enable = true;
        enableAllSections = true;
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

      search = {
        default = "DuckDuckGo";
        force = true;
        engines = {
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
      };

      settings = {
        "apz.overscroll.enabled" = true;
        "browser.aboutConfig.showWarning" = false;
        "general.autoScroll" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };
}
