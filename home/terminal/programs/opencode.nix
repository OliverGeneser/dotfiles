{
  inputs,
  pkgs,
  self,
  ...
}:
{
  programs.opencode = {
    enable = true;
    package =
      let
        opencodePkg = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      in
      (opencodePkg.override {
        #node_modules = opencodePkg.node_modules.override {
        #hash = "sha256-1tKRDDKUF+no53SwpTBB+cc81gF/shaaFkUwBmUX7Z8=";
        #};
      }).overrideAttrs
        (old: {
          postPatch = ''
            # NOTE: Relax Bun version check to be a warning instead of an error
            substituteInPlace packages/script/src/index.ts \
              --replace-fail 'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
                             'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
          '';
        });

    settings = {
      autoupdate = false;
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          headers = {
            "CONTEXT7_API_KEY" = "{env:CONTEXT7_API_KEY}";
          };
        };
        gh_grep = {
          type = "remote";
          url = "https://mcp.grep.app";
        };
      };
    };
  };
}
