{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    packages = rec {
      # instant repl with automatic flake loading
      repl = pkgs.callPackage ./repl {};
      snapraid-btrfs = pkgs.callPackage ./snapraid-btrfs {};
      snapraid-btrfs-runner = pkgs.callPackage ./snapraid-btrfs-runner {snapraid-btrfs = snapraid-btrfs;};
      wallpapers = pkgs.callPackage ./wallpapers {};
    };
  };
}
