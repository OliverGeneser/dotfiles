{
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
  '';

  services = {
    logind = {
      settings.Login = {
        HandlePowerKey = "suspend";
        HandleLidSwitch = "suspend-then-hibernate";
      };
    };

    power-profiles-daemon.enable = true;

    # battery info
    upower.enable = true;
  };
}
