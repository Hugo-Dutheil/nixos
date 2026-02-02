{ config, pkgs, inputs, settings, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      superedit = "sudo -e";
      config = ''
        cd ${settings.configPath} && nvim -c "e configuration.nix" -c "tabnew" -c "e flake.nix" -c "tabnew" -c "e home.nix"
      '';
      rebuild =
        "sudo sh ${settings.configPath}/scripts/pre-rebuild.sh && sudo nixos-rebuild switch --flake /home/${settings.username}/nixos#default --impure && sh ${settings.configPath}/scripts/post-rebuild.sh";
      gss = "git status";
      re = "source ~/.zshrc";
      zshconfig = "sudo nvim ~/.zshrc";
      spotify = "flatpak run com.spotify.Client";
      spiceUp = "sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify; sudo chmod a+wr -R /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/Apps";
      mktex = "sh ~/.bin/texTemplate.sh";
    };

    history = {
      size = 1000;
      save = 1000;
      share = false;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      custom = "${settings.configPath}/dotfiles/zsh";
      theme = "theme";
    };
  };
}
