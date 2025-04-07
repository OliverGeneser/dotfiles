{
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
  '';

  services = {
    logind = {
      powerKey = "suspend";
      lidSwitch = "suspend-then-hibernate";
    };

    power-profiles-daemon.enable = true;

    # battery info
    upower.enable = true;
  };
}
