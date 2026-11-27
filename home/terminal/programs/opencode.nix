{
  inputs,
  lib,
  pkgs,
  self,
  ...
}:
{
  programs.opencode = {
    enable = true;

    # Shared MCP servers from ./mcp.nix (context7, gh_grep).
    enableMcpIntegration = true;

    # stylix still sets `tui.theme`, but OpenCode 2 ignores tui.json. The
    # stylix theme file is still installed and selected via cli.json.
    tui = lib.mkForce { };

    package =

      let
        opencodePkg = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      in
      opencodePkg.overrideAttrs (old: {
        node_modules = old.node_modules.override {
          hash = "sha256-1XC9ohZg6TT/e4j3j0SYBThXuaCwGrAO3tWb1n50Nx4=";
        };
      });

    settings = {
      autoupdate = false;
      plugins = [ ];
      provider = {
        cern-litellm = {
          npm = "@ai-sdk/openai-compatible";
          name = "CERN LiteLLM";
          options = {
            baseURL = "{env:LITELLM_API_URL}";
            apiKey = "{env:LITELLM_API_KEY}";
          };
          models = {
            "gpt-5.6-sol" = {
              "name" = "GPT-5.6 Sol";
            };
            "gpt-5.6-terra" = {
              "name" = "GPT-5.6 Terra";
            };
            "gpt-5.6-luna" = {
              "name" = "GPT-5.6 Luna";
            };
          };
        };
      };
    };
  };
}
