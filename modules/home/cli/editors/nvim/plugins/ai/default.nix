{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.nixvim = {
    plugins = {
      ollama = {
        enable = true;
      };
    };

    extraPlugins = [
    ];
  };
}
