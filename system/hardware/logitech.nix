{ pkgs, ... }: {
  hardware = {
    logitech.wireless.enable = true;
  };

  programs.solaar.enable = true;

  environment.systemPackages = with pkgs; [
    solaar
  ];

  services.udev.packages = with pkgs; [
    logitech-udev-rules
    solaar
  ];
}
