{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.user;
in {
  options.user = with types; {
    name = mkOpt str "olivergeneser" "The name of the user's account";
    initialPassword =
      mkOpt str "test1234"
      "The initial password to use";
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions =
      mkOpt attrs {}
      "Extra options passed to users.users.<name>";
  };

  config = {
    users.users.olivergeneser =
      {
        isNormalUser = true;
        inherit (cfg) name initialPassword;
        home = "/home/olivergeneser";
        group = "users";

        extraGroups =
          ["wheel" "audio" "sound" "video" "networkmanager" "input" "tty"]
          ++ cfg.extraGroups;
      }
      // cfg.extraOptions;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
