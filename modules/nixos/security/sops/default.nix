{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.security.custom.sops;
in {
  options.security.custom.sops = with types; {
    enable = mkBoolOpt false "Whether to enable sop for secrets management.";
  };

  config = mkIf cfg.enable {
    sops = {
      age.sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
    };
  };
}
