{inputs, ...}: {
  imports = [inputs.git-hooks-nix.flakeModule];

  perSystem.pre-commit = {
    settings.excludes = ["flake.lock" "\\secrets\.yaml$"];

    settings.hooks = {
      alejandra.enable = true;
      prettier = {
        enable = true;
        excludes = [".js" ".md" ".ts"];
      };
    };
  };
}
