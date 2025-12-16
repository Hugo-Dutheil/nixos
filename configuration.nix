{ config, lib, pkgs, inputs, settings, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "${settings.username}-${settings.machine}";
  networking.networkmanager.enable = true;
  security.sudo.extraConfig = "
    Defaults   !sudoedit_checkdir
    "; # To impose sudo editor
  time.timeZone = "Europe/Amsterdam";

  console = {
    keyMap = "fr_CH-latin1";
    font = "Lat2-Terminus16";
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "
        ${pkgs.cage}/bin/cage -s -- \
          ${pkgs.greetd.gtkgreet}/bin/gtkgreet \
          --remember \
          --time
        ";
        user = "hdutheil";
      };
      initial_session = {
        command = "Hyprland";
        user = "hdutheil";
      };
    };
  };

#  Tuned
services.tuned.enable = true;
services.tlp.enable = false;

#  Fingerprint reader activation

  systemd.services.fprintd = {
    wantedBy = [ "mult-user.target"];
    serviceConfig.Type = "simple";
  };

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  security.pam.services = {
    sddm.fprintAuth = true;
    sddm-autologin.fprintAuth = true;
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    kscreenlocker.fprintAuth = true;
    polkit-1.fprintAuth = true;
  };
  security.pam.enableEcryptfs = false;  # (if relevant)
  services.dbus.enable = true;

  environment.etc."greetd/background.png".source = /home/hdutheil/Pictures/lockBG.png;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "net.reactivated.fprint.device.enroll" ||
           action.id == "net.reactivated.fprint.device.verify" ||
           action.id == "net.reactivated.fprint.device.list-enrolled-fingers" ||
           action.id == "net.reactivated.fprint.device.delete-enrolled-fingers") &&
          subject.isInGroup("users")) {
        return polkit.Result.YES;
      }
    });
  '';

  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
    shell = pkgs.shadow;
  };

  users.groups.greeter = {};

  services.printing.enable = false;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak install com.spotify.Client --noninteractive --assumeyes
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${settings.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ 
      tree 
      flatpak
      gnome-software
    ];
    shell = pkgs.zsh;
  };

  home-manager = { users = { "${settings.username}" = import ./home.nix; }; };
  home-manager.backupFileExtension = "backup";

  programs.zsh.enable = true;

  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages.${pkgs.system}.hyprland;

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    SUDO_EDITOR = "/home/$USER/.nix-profile/bin/nvim";
    EDITOR = "/home/$USER/.nix-profile/bin/nvim";
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs;
    [
      # Utils
      wget
      curl
      git
      alsa-utils
      wl-clipboard
      openssh
      upower
      zip
      unzip
      jq
      gparted
      nvtopPackages.full
      networkmanagerapplet
      pamtester
      fprintd
      tuned
      cifs-utils
      samba

      # Codecs
      libva
      libaacs
      ffmpeg-full
      mediastreamer
      openh264
      mediastreamer-openh264
      wineWowPackages.waylandFull

      # Software
      btop
      blueman
      pavucontrol
      yazi
      eog
      evince
      gnome-disk-utility
      firefox
      franz
      cava
      vesktop
      krita
      speedcrunch
      librewolf
      libreoffice-qt6-fresh
      godot

      # Env setup
      kitty
      nautilus
      where-is-my-sddm-theme
      hyprpaper
      eww
      zsh-powerlevel10k
      dunst
      libnotify
      hyprcursor
      greetd.gtkgreet
      cage
#       spicetify-cli
      libsForQt5.okular

      # Dev deps
      vscodium
      gcc15
      texlive.combined.scheme-basic
      cmake
      gnumake
      cargo
      rustc
      nodejs
      go
      gdb
      cgdb
      valgrind

      # Python libraries
      (python3.withPackages (python-pkgs: with python-pkgs; [
        numpy
        pandas
        matplotlib
        scipy
        numba
        jupyter notebook
      ]))
    ]; 

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.geist-mono
    nerd-fonts.go-mono
    nerd-fonts.gohufont
    font-awesome
  ];

  services.upower.enable = true;
# https://nixos.wiki/wiki/Spotify
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.devmon.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "${settings.nixosVersion}"; # Did you read the comment?

}

