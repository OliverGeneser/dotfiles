{ ... }:
{
  # Shared MCP servers consumed via `enableMcpIntegration` by
  # programs.opencode, programs.claude-code and programs.codex.
  # Secrets stay as `{env:...}` / file refs so they don't land in the store.
  programs.mcp = {
    enable = true;
    servers = {
      context7 = {
        url = "https://mcp.context7.com/mcp";
        headers = {
          CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
        };
      };
      gh_grep = {
        url = "https://mcp.grep.app";
      };
    };
  };
}
