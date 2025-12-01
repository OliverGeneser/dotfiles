{inputs, ...}: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
    };
  };

  # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
  security.rtkit.enable = true;
  services.pipewire = {
    lowLatency = {
      # enable this module
      enable = true;
      # defaults (no need to be set unless modified)
      quantum = 64;
      rate = 48000;
    };
  };

  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];
}
