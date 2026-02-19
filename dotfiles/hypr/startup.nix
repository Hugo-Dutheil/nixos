{ config, pkgs, inputs, settings, lib, ... }:

{
  wayland.windowManager.hyprland.settings.exec-once = [
    "sleep 1"
    "hyprctl reload"
    "qs -p ~/nixos/dotfiles/quickshell/shell.qml"
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "hyprctl setcursor Bibata-Modern-Classic 22"
    "$scripts/monitors-toggle.sh"
    "~/.bin/startSpotify.sh"
  ];
}
