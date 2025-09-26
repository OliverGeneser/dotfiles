{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    packages = rec {
      # instant repl with automatic flake loading
      gca = pkgs.callPackage ./gca {};
      helium = pkgs.callPackage ./helium {};
      repl = pkgs.callPackage ./repl {};
      snapraid-btrfs = pkgs.callPackage ./snapraid-btrfs {};
      snapraid-btrfs-runner = pkgs.callPackage ./snapraid-btrfs-runner {snapraid-btrfs = snapraid-btrfs;};
      wallpapers = pkgs.callPackage ./wallpapers {};
      wl-ocr = pkgs.callPackage ./wl-ocr {};
    };
  };
}
