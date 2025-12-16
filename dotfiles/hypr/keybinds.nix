{ config, pkgs, inputs, settings, ... }:

{
  wayland.windowManager.hyprland.settings = {
    binds = { allow_workspace_cycles = true; };

    bind = [
      "$mainMod, return, exec, $terminal"
      "$mainMod, backspace, killactive,"
      "$mainMod, B, exec, $browser"
      "$mainMod, DELETE, exit,"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, V, togglefloating,"
      "$mainMod, space, exec, $menu"
      "$mainMod, P, pseudo, # dwindle"
      "$mainMod, U, togglesplit, # dwindle"
      "$mainMod, F, fullscreen,"

  # Move focus with mainMod + arrow keys
      "$mainMod, h, movefocus, l"
      "$mainMod, l, movefocus, r"
      "$mainMod, k, movefocus, u"
      "$mainMod, j, movefocus, d"

      "$mainMod SHIFT, l, movewindow, r"
      "$mainMod SHIFT, h, movewindow, l"
      "$mainMod SHIFT, k, movewindow, d"
      "$mainMod SHIFT, j, movewindow, u"


  # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"
      "$mainMod, left, workspace, -1"
      "$mainMod, right, workspace, +1"

  # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"
      "$mainMod SHIFT, left, movetoworkspace, -1"
      "$mainMod SHIFT, right, movetoworkspace, +1"

      "$mainMod SHIFT ALT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT ALT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT ALT, 3, movetoworkspacesilent, 3"
      "$mainMod SHIFT ALT, 4, movetoworkspacesilent, 4"
      "$mainMod SHIFT ALT, 5, movetoworkspacesilent, 5"
      "$mainMod SHIFT ALT, 6, movetoworkspacesilent, 6"
      "$mainMod SHIFT ALT, 7, movetoworkspacesilent, 7"
      "$mainMod SHIFT ALT, 8, movetoworkspacesilent, 8"
      "$mainMod SHIFT ALT, 9, movetoworkspacesilent, 9"
      "$mainMod SHIFT ALT, 0, movetoworkspacesilent, 10"
      "$mainMod SHIFT ALT, left, movetoworkspacesilent, -1"
      "$mainMod SHIFT ALT, right, movetoworkspacesilent, +1"
  # Resizing windows
       "$mainMod ALT, U, resizeactive, -100 0"
       "$mainMod ALT, I, resizeactive, 0 -100"
       "$mainMod ALT, O, resizeactive, 0 100"
       "$mainMod ALT, U, resizeactive, -100 0"
       "$mainMod ALT, P, resizeactive, 100 0"

       "$mainMod ALT SHIFT, U, resizeactive, -10 0"
       "$mainMod ALT SHIFT, I, resizeactive, 0 -10"
       "$mainMod ALT SHIFT, O, resizeactive, 0 10"
       "$mainMod ALT SHIFT, U, resizeactive, -10 0"
       "$mainMod ALT SHIFT, P, resizeactive, 10 0"

# Example special workspace (scratchpad)
      "$mainMod, M, togglespecialworkspace, magic"
      "$mainMod SHIFT, M, movetoworkspace, special:magic"
      "$mainMod, S, togglespecialworkspace, spotify"
      "$mainMod SHIFT, S, movetoworkspace, special:spotify"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ];
    bindl = [
        # Media / audio
      ",XF86AudioLowerVolume, exec, $scripts/volumeControl.sh --dec"
      ",XF86AudioRaiseVolume, exec, $scripts/volumeControl.sh --inc"
      ",XF86AudioMute, exec, $scripts/volumeControl.sh --mute"

      # Monitor / keyboard brightness
      ",XF86MonBrightnessUp, exec, $scripts/monitorBacklight.sh --inc"
      ",XF86MonBrightnessDown, exec, $scripts/monitorBacklight.sh --dec"
      ",XF86KbdBrightnessUp, exec, $scripts/kbBacklight.sh --inc"
      ",XF86KbdBrightnessDown, exec, $scripts/kbBacklight.sh --dec"

      # Screenshot
    ];

    bindm =
      [ "$mainMod, mouse:272, movewindow" "$mainMod, mouse:273, resizewindow" ];
  };
}
