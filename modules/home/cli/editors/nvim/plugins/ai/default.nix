{
  config,
  pkgs,
  inputs,
  ...
}: let
  copilotchat-nvim = pkgs.vimUtils.buildVimPlugin {
    version = "latest";
    pname = "CopilotChat.nvim";
    src = inputs.copilotchat-nvim;
  };
in {
  programs.nixvim = {
    plugins = {
      ollama = {
        enable = true;
      };

      copilot-lua = {
        enable = true;
        suggestion.enabled = false;
        panel.enabled = false;
      };

      codeium-nvim = {
        enable = true;
      };
    };

    extraPlugins = [
      pkgs.vimPlugins.ChatGPT-nvim
      copilotchat-nvim
    ];
  };
}
