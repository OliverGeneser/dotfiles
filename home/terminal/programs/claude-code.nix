{ ... }:
{
  programs.claude-code = {
    enable = true;
    # Installs pkgs.claude-code (currently 2.1.x in nixpkgs-unstable).
    # No extra flake input needed - nixpkgs tracks Anthropic's npm release closely.

    # Pulls shared servers from programs.mcp (see ./mcp.nix).
    enableMcpIntegration = true;
  };
}
