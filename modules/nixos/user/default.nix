{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.user;
in {
  options.user = with types; {
    name = mkOpt str "olivergeneser" "The name of the user's account";
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions =
      mkOpt attrs {}
      "Extra options passed to users.users.<name>";
  };

  config = {
    sops.secrets.password = {
      sopsFile = ../secrets.yaml;
      neededForUsers = true;
    };

    users.mutableUsers = false;
    users.users.${cfg.name} =
      {
        isNormalUser = true;
        inherit (cfg) name;

        # initialPassword ="test1234";
        hashedPasswordFile = config.sops.secrets.password.path;

        home = "/home/${cfg.name}";
        group = "users";

        extraGroups =
          [
            "wheel"
            "audio"
            "sound"
            "video"
            "render"
            "networkmanager"
            "input"
            "tty"
            "kvm"
            "adbusers"
            "libvirtd"
            "gamemode"
            "dialout"
          ]
          ++ cfg.extraGroups;
      }
      // cfg.extraOptions;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
