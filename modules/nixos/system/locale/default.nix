{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.locale;
in {
  options.system.locale = with types; {
    enable = mkBoolOpt false "Whether or not to manage locale settings.";
  };

  config = mkIf cfg.enable {
    i18n = {
      defaultLocale = lib.mkDefault "en_DK.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "en_DK.UTF-8";
        LC_IDENTIFICATION = "en_DK.UTF-8";
        LC_MEASUREMENT = "en_DK.UTF-8";
        LC_MONETARY = "en_DK.UTF-8";
        LC_NAME = "en_DK.UTF-8";
        LC_NUMERIC = "en_DK.UTF-8";
        LC_PAPER = "en_DK.UTF-8";
        LC_TELEPHONE = "en_DK.UTF-8";
        LC_TIME = "en_DK.UTF-8";
      };
    };
    time.timeZone = "Europe/Copenhagen";

    # Configure keymap in X11
    services.xserver = {
      xkb.layout = "us";
      xkb.variant = "altgr-intl";
    };
    # Configure console keymap
    console.keyMap = "us";
  };
}
