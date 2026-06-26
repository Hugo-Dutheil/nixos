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
    ./dotfiles/flameshot.nix
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

  
  programs.neovim = {
    enable = true;
    extraLuaPackages = ps: [ 
      ps.magick 
    ];
    
    extraPython3Packages = ps: with ps; [
      pynvim
      jupyter-client
      ipykernel
      pnglatex
      pyperclip
      nbformat
      cairosvg
      pillow

      numpy
      pandas
      matplotlib
      scipy
      numba
      jupyter notebook
      setuptools
      flask
      skyfield
      astropy
      pyjwt
      python-dotenv
      cryptography
    ];
    extraPackages = with pkgs; [
      imagemagick
      python3Packages.jupytext
      tree-sitter
      python3Packages.pynvim
      python3Packages.jupyter-client
      python3Packages.ipykernel
      python3Packages.nbformat
      python312Packages.pylatexenc
    ];

    extraLuaConfig = ''
      vim.g.python3_host_prog = "${pkgs.python3}/bin/python3"
    '';
  };
}

