{
  systemd.sleep.settings.Sleep = ''
    HibernateDelaySec=30min
  '';

  services = {
    logind = {
      settings.Login = {
        HandlePowerKey = "suspend";
        HandleLidSwitch = "suspend-then-hibernate";
      };
    };

    # battery info
    upower.enable = true;
  };
}
