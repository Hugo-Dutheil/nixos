{ lib, config, pkgs, inputs, settings, ... }:

{
  imports = [ ./keybinds.nix ./startup.nix ./windowrules.nix ];

  # Dependencies for the Hyprland setup
  home.packages = with pkgs; [
    bibata-cursors
    hyprcursor # Watch for plugin possibly
    wofi
    playerctl
    swaybg # Watch for plugin possibly
    hyprpaper
    hypridle # Watch for plugin possibly
    wlogout
    grim
    slurp
    hyprlock # Watch for plugin possibly
    brightnessctl
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      monitor = ["eDP-1, 1920x1200@60.00Hz,0x0, 1.0"];
      "$mainMod" = "SUPER";
      "$scripts" = "${settings.configPath}/scripts";
      "$wallpaper" = "${settings.configPath}/dotfiles/hypr/wallpaper.png";
      "$terminal" = "kitty";
      "$browser" = "zen";
      "$fileManager" = "nautilus";
      "$menu" = "wofi";

      env = [
        "HYPRCURSOR_THEME,gg"
        "HYPRCURSOR_SIZE,22"
        "XCURSOR_SIZE, 24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

      cursor.enable_hyprcursor = true;

      misc = {
        force_default_wallpaper = 1;
        disable_hyprland_logo = true;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };

      decoration = {
        rounding = 15;
        blur = {
          enabled = true;
          size = 3;
          passes = 3;
          new_optimizations=1;
          ignore_opacity = false;
        };
        dim_inactive = true;
        dim_strength = 0.1;
      };
      animations = {
        enabled = true;
        # Custom animations really fast
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [

          "windows, 1, 7, myBezier, popin 80%"
          "windowsOut, 1, 7, default, popin 70%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 6, default"
          "workspaces, 1, 7, default"
          "specialWorkspace, 1, 7, myBezier, slidevert"
        ];
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      xwayland.force_zero_scaling = true;
      gestures.workspace_swipe = true;

      input = {
        kb_layout = "ch";
        kb_variant = "fr";
        kb_options = "";
        follow_mouse = 1;
        touchpad = { natural_scroll = true; };
        sensitivity = 0; # -1.0 to 1.0, 0 means no modification.
      };

      device = [
        {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        }
      ];
    };
  };
}
