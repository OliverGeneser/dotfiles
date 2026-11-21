{
  services.gammastep = {
    enable = true;
    tray = true;

    # stopgap until geoclue's wifi location is fixed
    provider = "manual";
    latitude = 55.6761;
    longitude = 12.5683;

    temperature = {
      day = 6500;
      night = 4500;
    };

    enableVerboseLogging = true;

    settings.general.adjustment-method = "wayland";
  };
}
