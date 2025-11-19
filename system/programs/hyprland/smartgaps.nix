{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.programs.hyprland.settings.general) gaps_in gaps_out border_size;
  inherit (config.programs.hyprland.settings.decoration) rounding;
  inherit (builtins) concatStringsSep;
  inherit (lib.lists) flatten;

  workspaceSelectors = ["w[t1]" "w[tg1]" "f[1]"];

  toggleSmartGaps = let
    forEach = f: concatStringsSep "\n" (map f workspaceSelectors);
  in
    pkgs.writeShellScript "toggleSmartGaps" ''
      hyprctl -j workspacerules | ${lib.getExe pkgs.jaq} -e 'any(.[]; select(.workspaceString == "w[t1]" or .workspaceString == "w[tg1]" or .workspaceString == "w[f1]") | (.gapsIn | all(. == 0)) and (.gapsOut | all(. == 0)))' > /dev/null

      if [ $? -eq 0 ]; then
      ${forEach (selector: ''
        hyprctl keyword workspace "${selector}, gaps_out ${toString gaps_out}, gaps_in ${toString gaps_in}"
        hyprctl keyword windowrule "match:workspace ${selector}, border_size ${toString border_size}, float 0"
        hyprctl keyword windowrule "match:workspace ${selector}, rounding ${toString rounding}, float 0"
      '')}
      else
      ${forEach (selector: ''
        hyprctl keyword workspace "${selector}, gaps_out 0, gaps_in 0"
        hyprctl keyword windowrule "match:workspace ${selector}, border_size 0, float 0"
        hyprctl keyword windowrule "match:workspace ${selector}, rounding 0, float 0"
      '')}
      fi
    '';
in {
  # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
  # "Smart gaps" / "No gaps when only"
  programs.hyprland.settings = {
    workspace = map (x: "${x}, gaps_out 0, gaps_in 0") workspaceSelectors;

    windowrule = flatten (map (x: [
        "match:workspace ${x}, border_size 0, float 0"
        "match:workspace ${x}, rounding 0, float 0"
      ])
      workspaceSelectors);

    bind = [
      "$mod, M, exec, ${toggleSmartGaps}"
    ];
  };
}
