{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.service.ollama;
in
{
  options.service.ollama = {
    enable = mkEnableOption "Enable Ollama service";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ollama
    ];

    #services.ollama = {
    #  enable = true;
    #  acceleration = "cuda";
    #};
  };
}
