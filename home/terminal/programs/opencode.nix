{
  inputs,
  pkgs,
  self,
  ...
}: {
  programs.opencode = {
    enable = true;
    package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      autoupdate = true;
      plugin = ["@ex-machina/opencode-anthropic-auth@1.8.0"];
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
