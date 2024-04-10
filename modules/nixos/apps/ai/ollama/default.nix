{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.ai.ollama;
in {
  options.apps.ai.ollama = with types; {
    enable = mkBoolOpt false "Enable or disable ollama";
  };

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      acceleration = "cuda";
    }

    home.persist.directories = [
      ".ollama"
      ".cache/ollama"
    ];
  };
}
