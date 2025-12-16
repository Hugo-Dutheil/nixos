{ lib, config, pkgs, inputs, settings, ...}:

{
  xdg.configFile = {
    "quickshell" = {
      source = "${settings.configPath}/dotfiles/quickshell";
      recursive = true;
    };
  };
}
