{ lib, config, pkgs, inputs, settings, ...}:

{
  home.packages = with pkgs; [ ripgrep fd fzf gcc cargo rustc ];
  xdg.configFile = {
    "spicetify" = {
      source = "${settings.configPath}/dotfiles/spicetify";
      recursive = true;
    };
  };
}
