{ ... }:
{
  programs.codex = {
    enable = true;
    # Installs pkgs.codex (currently 0.167.x in nixpkgs-unstable).
    # No extra flake input needed - nixpkgs tracks openai/codex closely.

    # Pulls shared servers from programs.mcp (see ./mcp.nix).
    enableMcpIntegration = true;
  };
}
