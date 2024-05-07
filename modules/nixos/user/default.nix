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
    users.mutableUsers = false;
    users.users.olivergeneser =
      {
        isNormalUser = true;
        inherit (cfg) name;
        hashedPassword = "$6$fGDkSQ/rlUmeMmpx$L3cNIDSUVuetvqVdwgynz4m3IrPEukPcMPzjvS84zaxkU1xNOglduoFDgsHSVqSSjUZOydCGvoEpbzJTFktV/1";
        home = "/home/olivergeneser";
        group = "users";

        extraGroups =
          ["wheel" "audio" "sound" "video" "render" "networkmanager" "input" "tty"]
          ++ cfg.extraGroups;
      }
      // cfg.extraOptions;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };
  };
}
