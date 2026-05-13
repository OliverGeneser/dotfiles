{ config, ... }:
{
  services.syncthing = {
    enable = true;

    overrideDevices = true; # overrides any devices added or deleted through the WebUI
    overrideFolders = true; # overrides any folders added or deleted through the WebUI

    guiAddress = "0.0.0.0:8384";

    settings = {
      gui = {
        user = "${config.home.username}";
        password = "password";
      };
    };
  };
}
