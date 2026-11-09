{
  pkgs,
  lib,
  ...
}:
{
  security.rtkit.enable = true;

  programs.dconf.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    pulseaudio.enable = lib.mkForce false;
  };

  environment.systemPackages = with pkgs; [
    pulseaudio
    pipewire.jack
  ];
}
