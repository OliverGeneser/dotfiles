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
          hash = "sha256-pKxA4f8E9DJVBNWLtEJEHhzbWp2R6H05Mkcjk4I8Xk0=";
        };

        # v2 removed the `completion` subcommand (yargs -> effect/cli) but
        # nix/opencode.nix:87 still runs `installShellCompletion --cmd opencode --bash <($out/bin/opencode completion)`.
        # That is now interpreted as `opencode <directory>` and hits packages/cli/src/commands/handlers/default.ts:19 `process.chdir(requestedDirectory)` -> ENOENT.
        # Disable broken shell-completion generation until upstream fixes nix/opencode.nix.
        postInstall = "";
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
