{
  # network discovery, mDNS
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    settings.publish = {
      disable-publishing = false;
      publish-domain = true;
      disable-user-service-publishing = false;
    };
  };
}
