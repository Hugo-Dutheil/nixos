{ config, pkgs, settings, colors, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
#           "layer": "top", # Waybar at top layer
#           "position": "bottom", # Waybar position (top|bottom|left|right)
          height = 45; # Waybar height (to be removed for auto height)
#           "width": 1280, # Waybar width
          spacing = 4; # Gaps between modules (4px)
          modules-left = [
              "hyprland/workspaces"
              "custom/cava"
#               "hyprland/mode",
#               "hyprland/scratchpad"
          ];
          modules-center = [
              "mpris"
          ];
          modules-right =  [
              "idle_inhibitor"
              "load"
              "wireplumber"
              "backlight"
              "clock"
              "battery"
              "tray"
              "custom/nmApplet"
              "custom/bluetoothCustom"
          ];


          "custom/nmApplet" = {
            "exec" = "nm-applet --indicator";
          };

#           Modules configuration
          "hyprland/workspaces" = {
              "all-outputs" = true;
              "warp-on-scroll" = false;
              "enable-bar-scroll" = true;
              "disable-scroll-wraparound" = true;
              "format" = "{name} {icon}";
              "format-icons" = {
                  "active" = "";
                  "default" = "";
              };
          };
          "sway/window" = {
              "format" = "{title}";
              "max-length" = 40;
              "all-outputs" = true;
          };
      "custom/cava" = {
          "format" = "{text}";
          "format-icons" = {
              "Playing" = "  ⏸  "; # Uncomment if not using caway
              "Paused" = "  ▶  ";
              "Stopped" = "   &#x202d;ﭥ   "; # This stop symbol is RTL. So &#x202d; is left-to-right override.
          };
          "escape" = true;
          "tooltip" = true;
          "exec" = "/home/hdutheil/.bin/cava_config.sh";
          "return-type" = "json";
          "on-click" = "playerctl play-pause";
          "on-scroll-up" = "playerctl previous";
          "on-scroll-down" = "playerctl next";
          "on-click-right" = "g4music";
          "max-length" = 45;
        };
        "custom/bluetoothCustom" = {
          "exec" = "/home/hdutheil/.bin/WBbtWidget/bluetoothConfig.sh";
          "tooltip" = true;
          "tooltip-format" = "{text}";
          "format" = "{icon} {alt}";
          "return-type" = "json";
          "interval" = "once";
          "signal" = 9;
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
          "on-click" = "/home/hdutheil/.bin/WBbtWidget/UI.sh";
          "on-click-right" = "/home/hdutheil/.bin/WBbtWidget/settingsMenu.sh";
        };
        "mpris" = {
        "format" = "  {status_icon} {dynamic}";
        "interval" = 1;
        "dynamic-len" = 40;
        "status-icons" = {
          "playing" = " ⏸ "   ;
          "paused" = " ▶ ";
          "stopped" = "  ";
        };
        "dynamic-order" = ["title" "artist"];
        "ignored-players" = ["firefox"];
          };
          "idle_inhibitor" = {
              "format" = "{icon}";
              "format-icons" = {
                  "activated" = "";
                  "deactivated" = "";
              };
          };
          "sway/scratchpad" = {
              "format" = "{icon} {count}";
              "show-empty" = false;
              "format-icons" = ["" ""];
              "tooltip" = true;
              "tooltip-format" = "{app}: {title}";
          };
          "tray" = {
              "icon-size" = 14;
              "spacing" = 10; 
          };
          "load" = {
              "format" = " {}";
          };
          "clock" = {
#               "timezone" = "America/New_York";
              "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              "format-alt" = "{:%Y-%m-%d}";
          };
          "cpu" = {
              "format" = "{usage}% ";
              "tooltip" = false;
          };
          "memory" = {
              "format" = "{}% ";
          };
          "temperature" = {
#               "thermal-zone" = 2;
#               "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
              "critical-threshold" = 80;
#               "format-critical" = "{temperatureC}°C {icon}";
              "format" = "{temperatureC}°C {icon}";
              "format-icons" = ["" "" ""];
          };
          "backlight" = {
#               "device" = "acpi_video1";
              "format" = "{icon} {percent}%";
              "format-icons" = ["""" "" "" "" "" "" ""];
          };
          "battery" = {
              "states" = {
#                   "good" = 95;
                  "warning" = 30;
                  "critical" = 15;
              };
              "format" = "{icon} {capacity}%";
              "format-full" = "{icon} {capacity}%";
              "format-charging" = " {capacity}%";
              "format-plugged" = " {capacity}%";
              "format-alt" = "{icon} {time}";
#               "format-good" = ""; # An empty format will hide the module
#               "format-full" = "";
              "format-icons" = ["" "" "" "" ""];
          };
          "wireplumber" = {
              "scroll-step" = 5; # %, can be a float
              "format" = "{icon} {volume}%";
              "format-bluetooth" = "{icon} {volume}% ";
              "format-bluetooth-muted" = "#&f6a9 {icon}";
              "format-muted" = " ";
              "format-icons" = {
                  "headphone" = "";
                  "hands-free" = "";
                  "headset" = "";
                  "phone" = "";
                  "portable" = "";
                  "car" = "";
                  "default" = ["" "" ""];
              };
              "on-click" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          
          };
      };
    };

#         layer = "top";
#         position = "top";
#         height = 30;
#         modules-left = [ "hyprland/workspaces" ];
#         modules-center = [ "custom/player" ];
#         modules-right = [
#           "pulseaudio"
#           "network"
#           "battery"
#           # "battery#bat2"
#           "clock"
#           "custom/wlogout"
#         ];
# 
#         "hyprland/workspaces" = {
#           disable-scroll = true;
#           disable-markup = true;
#           all-outputs = true;
#           format = " {icon} ";
#           format-icons = {
#             "active" = "";
#             "empty" = "";
#             "default" = "";
#           };
#           persistent-workspaces = { "*" = 5; };
#         };
#         "clock" = {
#           tooltip-format = "{:%d-%m-%Y | %H:%M}";
#           format-alt = "{:%d-%m-%Y}";
#         };
#         "cpu" = { format = "{usage}%  "; };
#         "battery" = {
#           states = {
#             "good" = 95;
#             "warning" = 30;
#             "critical" = 15;
#           };
#           format = "{icon}  {capacity}%";
#           tooltip-format = "{power}W";
#           format-icons = [ "" "" "" "" "" ];
#         };
#         "battery#bat2" = { bat = "BAT2"; };
#         "network" = {
#           format-wifi = " ";
#           format-ethernet = " 󰛳 ";
#           format-disconnected = " 󰖪 ";
#           tooltip-format = "{essid} {rignalStrength}%";
#           interval = 7;
#           on-click = "nm-connection-editor";
#         };
#         "pulseaudio" = {
#           format = "{volume}% {icon}";
#           format-bluetooth = "{volume}% {icon}";
#           format-muted = "{volume}% ";
#           format-icons = {
#             "headphones" = "";
#             "headset" = "";
#             "phone" = "";
#             "portable" = "";
#             "car" = "";
#             "default" = [ "" "" ];
#           };
#           on-click = "pavucontrol";
#         };
#         "bluetooth" = {
#           format = "  ";
#           tooltip-format = "{status}";
#           on-click = "blueman-manager";
#         };
#         "custom/player" = {
#           interval = 1;
#           return-type = "json";
#           exec = "${settings.configPath}/dotfiles/waybar/player.sh";
#           exec-if = "pgrep spotify || pgrep zen";
#           escape = true;
#           tooltip = true;
#         };
# 
#         "custom/wlogout" = {
#           tooltip = true;
#           tooltip-format = "Power menu";
#           format = "";
#           on-click = "${settings.configPath}/dotfiles/waybar/wlogout.sh";
#         };

    style = ''
      * {
          font-family: "JetBrains Mono Nerd Font", "Symbola", "Font Awesome 6 Free";
          font-size: 14px;
          border-radius: 5px;
      }

      window#waybar {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: "Noto Sans";
          background-color: transparent;
          border-bottom: 0px;
          color: #ebdbb2;
          transition-property: background-color;
          transition-duration: .5s;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      #custom-cava {
        font-family: Symbola;
        font-size: 16px;
        color: #6ee7b7; /* light green */
        padding: 0 8px;
      }

      window#waybar.empty #window {
          background-color: transparent;
      }

      /*
      window#waybar.empty {
          background-color: transparent;
      }
      window#waybar.solo {
          background-color: #FFFFFF;
      }
      */

      .modules-right {
          margin: 10px 10px 0 0;
      }
      .modules-center {
          margin: 10px 0 0 0;
      }
      .modules-left {
          margin: 10px 0 0 10px;
      }

      button {
          /* Use box-shadow instead of border so the text isn't offset */
          /* box-shadow: inset 0 -3px transparent; */
          border: none;
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      /*
      button:hover {
          background: inherit;
          box-shadow: inset 0 -3px #ebdbb2;
      } */

      #workspaces {
          background-color: #282828;
      }

      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #ebdbb2;
          border-radius: 0;
      }

      #workspaces button:first-child {
          border-radius: 5px 5px 5px 5px;
      }

      #workspaces button:last-child {
          border-radius: 5px 5px 5px 5px;
      }

      #workspaces button:hover {
          color: #d79921;
      }

      #workspaces button.focused {
          background-color: #665c54;
          /* box-shadow: inset 0 -3px #ffffff; */
      }

      #workspaces button.urgent {
          background-color: #b16286;
      }
      #workspaces
      #idle_inhibitor,
      #custom-cava,
      #scratchpad,
      #mode,
      #window,
      #clock,
      #battery,
      #backlight,
      #wireplumber,
      #tray,
      #mpris,
      #nmApplet,
      #custom-bluetoothCustom,
      #load {
          padding: 0 10px;
          background-color: #282828;
          color: #ebdbb2;
      }

      #mode {
          background-color: #689d6a;
          color: #282828;
          /* box-shadow: inset 0 -3px #ffffff; */
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }
      #nmApplet {
        padding: 0 5px;
      }
      #custom-bluetoothCustom {
        padding: 0 5px;
      }
      #cava {
          padding: 0 5px;
      }

      #battery.charging, #battery.plugged {
          background-color: #98971a;
          color: #282828;
      }

      @keyframes blink {
          to {
              background-color: #282828;
              color: #ebdbb2;
          }
      }

      /* Using steps() instead of linear as a timing function to limit cpu usage */
      #battery.critical:not(.charging) {
          background-color: #cc241d;
          color: #ebdbb2;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      label:focus {
          background-color: #000000;
      }

      #wireplumber.muted {
          background-color: #458588;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
      }

      #mpris.playing {
          background-color: #d79921;
          color: #282828;
      }

      #tray menu {
          font-family: FontAwesome, monospace;
      }

      #scratchpad.empty {
          background: transparent;
      }
    '';
  };
}


# { config, pkgs, settings, colors, ... }:
# 
# {
#   programs.waybar = {
#     enable = true;
# 
#     settings = {
#       mainBar = {
#         layer = "top";
#         position = "top";
#         height = 30;
#         modules-left = [ "hyprland/workspaces" ];
#         modules-center = [ "custom/player" ];
#         modules-right = [
#           "pulseaudio"
#           "network"
#           "battery"
#           # "battery#bat2"
#           "clock"
#           "custom/wlogout"
#         ];
# 
#         "hyprland/workspaces" = {
#           disable-scroll = true;
#           disable-markup = true;
#           all-outputs = true;
#           format = " {icon} ";
#           format-icons = {
#             "active" = "";
#             "empty" = "";
#             "default" = "";
#           };
#           persistent-workspaces = { "*" = 5; };
#         };
#         "clock" = {
#           tooltip-format = "{:%d-%m-%Y | %H:%M}";
#           format-alt = "{:%d-%m-%Y}";
#         };
#         "cpu" = { format = "{usage}%  "; };
#         "battery" = {
#           states = {
#             "good" = 95;
#             "warning" = 30;
#             "critical" = 15;
#           };
#           format = "{icon}  {capacity}%";
#           tooltip-format = "{power}W";
#           format-icons = [ "" "" "" "" "" ];
#         };
#         "battery#bat2" = { bat = "BAT2"; };
#         "network" = {
#           format-wifi = " ";
#           format-ethernet = " 󰛳 ";
#           format-disconnected = " 󰖪 ";
#           tooltip-format = "{essid} {rignalStrength}%";
#           interval = 7;
#           on-click = "nm-connection-editor";
#         };
#         "pulseaudio" = {
#           format = "{volume}% {icon}";
#           format-bluetooth = "{volume}% {icon}";
#           format-muted = "{volume}% ";
#           format-icons = {
#             "headphones" = "";
#             "headset" = "";
#             "phone" = "";
#             "portable" = "";
#             "car" = "";
#             "default" = [ "" "" ];
#           };
#           on-click = "pavucontrol";
#         };
#         "bluetooth" = {
#           format = "  ";
#           tooltip-format = "{status}";
#           on-click = "blueman-manager";
#         };
#         "custom/player" = {
#           interval = 1;
#           return-type = "json";
#           exec = "${settings.configPath}/dotfiles/waybar/player.sh";
#           exec-if = "pgrep spotify || pgrep zen";
#           escape = true;
#           tooltip = true;
#         };
# 
#         "custom/wlogout" = {
#           tooltip = true;
#           tooltip-format = "Power menu";
#           format = "";
#           on-click = "${settings.configPath}/dotfiles/waybar/wlogout.sh";
#         };
#       };
# 
#     };
#     style = ''
#       * {
#         border: none;
#         border-radius: 0;
#         font-family: GeistMono NF;
#         font-size: 13px;
#         min-height: 0;
#       }
# 
#       window#waybar {
#         background-color: transparent;
#         border: 0px solid alpha(${colors.waybar.border}, 0.3);
#         color: ${colors.waybar.text};
#       }
# 
#       .modules-left {
#         background-color: alpha(${colors.waybar.background}, 0.75);
#         border-radius: 6px;
#         margin-top: 3px;
#         margin-left: 3px;
#       }
# 
#       .modules-center {
#         background-color: alpha(${colors.waybar.background}, 0.75);
#         padding: 0px 10px;
#         border-radius: 6px;
#         margin-top: 3px;
#       }
# 
#       .modules-right {
#         background-color: alpha(${colors.waybar.background}, 0.75);
#         border-radius: 6px;
#         padding: 0px 6px;
#         margin-top: 3px;
#         margin-right: 3px;
#       }
# 
#       window#waybar.hidden {
#         opacity: 0;
#       }
# 
#       #workspaces {
#         margin-left: 3px;
#         margin-right: 3px;
#         padding: 0 5px;
#       }
# 
#       #workspaces button {
#         padding: 0 1px;
#         background: transparent;
#         border-bottom: 0px solid transparent;
#         min-width: 0px;
#         color: ${colors.waybar.text};
#       }
# 
#       #workspaces button.active {
#         color: ${colors.waybar.accent0};
#       }
# 
#       #workspaces button:hover {
#         box-shadow: inherit;
#         text-shadow: inherit;
#         color: ${colors.waybar.accent1};
#       }
# 
#       #workspaces button.urgent {
#         background-color: ${colors.waybar.red};
#       }
# 
#       #clock,
#       #battery,
#       #network,
#       #pulseaudio,
#       #cpu #custom-player {
#         padding: 0 6px;
#         margin: 0 5px;
#       }
# 
#       #custom-wlogout {
#         border-radius: 0.5rem;
#         padding: 0px 16px 0px 6px;
#         font-size: 12px;
#         /* add padding to left to keep it from being sticked to the left side*/
#       }
# 
#       #clock:hover,
#       #battery:hover,
#       #network:hover,
#       #pulseaudio:hover,
#       #cpu:hover,
#       #custom-player:hover,
#       #custom-wlogout:hover {
#         color: ${colors.waybar.accent1};
#       }
# 
#       #cpu {
#         padding: 0 3px;
#         margin: 0 0px;
#       }
# 
#       #battery.warning {
#         color: ${colors.waybar.yellow};
#         border-radius: 6px;
#       }
# 
#       #battery.critical {
#         color: ${colors.waybar.red};
#         border-radius: 6px;
#       }
# 
#       #battery.charging {
#         color: ${colors.waybar.green};
#         border-radius: 6px;
#       }
# 
#       tooltip {
#         background-color: ${colors.waybar.background};
#         border-radius: 3px;
#       }
# 
#       tooltip label {
#         color: ${colors.waybar.text};
#       }
#     '';
#   };
# }
