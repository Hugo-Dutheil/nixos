{config, pkgs, lib, ...}:
{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
          
        # More settings may be found on the Flameshot Github

        # Save Path
        savePath = "/home/hdutheil/Pictures/Screenshots";
        # Tray
        disabledTrayIcon = true;
        # Greeting message   
        showStartupLaunchMessage = false;
        # Default file extension for screenshots (.png by default)
        saveAsFileExtension = ".png";
        # Desktop notifications
        showDesktopNotification = true;
        # Whether to show the info panel in the center in GUI mode
        showHelp = true;
        # Whether to show the left side button in GUI mode
        showSidePanelButton = true;


        # Color Customization
        uiColor = "#740096";
        contrastUiColor = "#270032";
        drawColor = "#ff0000";

        # Stops warnings for using Grim
        disabledGrimWarning = true;
      };
    };
  };
}
