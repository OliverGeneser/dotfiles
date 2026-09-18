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
        node_modules = opencodePkg.node_modules.override {
          hash = "sha256-Ppc2Kgb9D9xdkrNMyQgPS6rn/zU5zMqMKvAmrFCj1zQ=";
        };
      });
    settings = {
      autoupdate = false;
      # plugin = [ "@ex-machina/opencode-anthropic-auth@1.8.1" ];
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
