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

    # battery info
    upower.enable = true;
  };
}
