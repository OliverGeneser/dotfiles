{ inputs, pkgs, ... }: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
      custom =
        let
          qs = "${pkgs.quickshell}/bin/qs";
        in
        {
          start = "${qs} ipc call notifications disable";
          end = "${qs} ipc call notifications disable";
        };
    };
  };

  # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
  security.rtkit.enable = true;
  services.pipewire = {
    lowLatency = {
      # enable this module
      enable = false;
      # defaults (no need to be set unless modified)
      quantum = 64;
      rate = 48000;
    };
  };

  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];
}
