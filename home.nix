{ lib, config, pkgs, inputs, settings, colors, ... }:

{
  imports = [
    ./dotfiles/ghostty.nix
    ./dotfiles/zen.nix
    ./dotfiles/fastfetch/fastfetch.nix
    ./dotfiles/tmux.nix
    ./dotfiles/waybar/waybar.nix
    ./dotfiles/zsh/zsh.nix
    ./dotfiles/hypr/hyprland.nix
    ./dotfiles/hypr/hyprlock.nix
    ./dotfiles/hypr/hypridle.nix
    ./dotfiles/hypr/hyprpaper.nix
    ./dotfiles/wlogout/wlogout.nix
    ./dotfiles/theming.nix
    ./dotfiles/wofi.nix
    ./dotfiles/neovim.nix
    ./dotfiles/spicetify.nix
    ./dotfiles/quickshell.nix
  ];

  home.username = "${settings.username}";
  home.homeDirectory = "/home/${settings.username}";

  home.stateVersion = "${settings.nixosVersion}";
  
  home.sessionVariables = {
    SUDO_EDITOR = "/home/$USER/.nix-profile/bin/nvim";
    EDITOR = "/home/$USER/.nix-profile/bin/nvim";
  };

  programs.home-manager.enable = true;
  home.packages  =  [
    inputs.quickshell.packages.${pkgs.system}.default
  ];
  programs.git = {
    enable = true;
    userName = "Hugo-Dutheil";
    userEmail = "hugo.dutheil@ik.me";

    signing = {
      format = "ssh";
      signByDefault = true;
    };

    extraConfig = {
      user.signingkey = "/home/${settings.username}/.ssh/id_ed25519.pub";
    };
  };
}
