{ config, pkgs, inputs, settings, lib, ... }:

{
  wayland.windowManager.hyprland.settings.windowrule = [
    "suppressevent maximize, class:.*"
    "float, title:Picture-in-Picture"
    "suppressevent maximize, class:.*"
    "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
    "float, class:^(org.matplotlib.Matplotlib3)$"
  ];
}
