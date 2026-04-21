{
  inputs,
  pkgs,
  self,
  ...
}: {
  programs.opencode = {
    enable = true;
    package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
      preBuild =
        (old.preBuild or "")
        + ''
          substituteInPlace packages/opencode/src/cli/cmd/generate.ts \
            --replace-fail 'const prettier = await import("prettier")' 'const prettier: any = { format: async (s: string) => s }' \
            --replace-fail 'const babel = await import("prettier/plugins/babel")' 'const babel = {}' \
            --replace-fail 'const estree = await import("prettier/plugins/estree")' 'const estree = {}'
        '';
    });
    settings = {
      autoupdate = true;
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
