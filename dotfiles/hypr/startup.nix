{ config, pkgs, inputs, settings, lib, ... }:

{
  wayland.windowManager.hyprland.settings.exec-once = [
    "hyprpaper"
    "qs -p ~/.config/quickshell/shell.qml"
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "hyprctl setcursor Bibata-Modern-Classic 22"
    "$scripts/monitors-toggle.sh"
    "~/.bin/startSpotify.sh"
  ];
}
