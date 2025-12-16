# { config, pkgs, inputs, settings, ... }:
#   
# {
# 
#   programs.hyprpaper = {
#     enable = true;
# 
#     settings = {
#       preload = /home/hdutheil/Pictures/newKittybg.jpg
#       #if more than one preload is desired then continue to preload other backgrounds
#       # preload = /path/to/next_image.png
#       # .. more preloads
# 
#       #set the default wallpaper(s) seen on initial workspace(s) --depending on the number of monitors used
#       wallpaper = eDP-1,/home/hdutheil/Pictures/newKittybg.jpg
#       #if more than one monitor in use, can load a 2nd image
#       # wallpaper = monitor2,/path/to/next_image.png
#       # .. more monitors
# 
#       #enable splash text rendering over the wallpaper
#       splash = false
# 
#       #fully disable ipc
#       # ipc = off
# 
#     }
#   }
# }
{ config, pkgs, ... }:

let
  wallpaperPath = "/home/hdutheil/Pictures/newKittybg_cropped.jpg";
in
{
  home.packages = with pkgs; [
    hyprpaper
  ];

  systemd.user.services.hyprpaper = {
    Unit = {
      Description = "Hyprland wallpaper daemon";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${wallpaperPath}
    wallpaper = eDP-1, ${wallpaperPath}
    splash = false
  '';
}
