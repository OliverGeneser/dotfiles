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
      opencodePkg.overrideAttrs (old: {
        node_modules = old.node_modules.override {
          hash = "sha256-HRwQ1DFTOY2ninqmRT2EJiAPOngNajgyGC4q3NPT2VI=";
        };

        # v2 removed the `completion` subcommand (yargs -> effect/cli) but
        # nix/opencode.nix:87 still runs `installShellCompletion --cmd opencode --bash <($out/bin/opencode completion)`.
        # That is now interpreted as `opencode <directory>` and hits packages/cli/src/commands/handlers/default.ts:19 `process.chdir(requestedDirectory)` -> ENOENT.
        # Disable broken shell-completion generation until upstream fixes nix/opencode.nix.
        postInstall = "";
      });

    settings = {
      autoupdate = false;
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
      mcp = {
        servers = {
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
  };
}
