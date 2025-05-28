# Hyprland scripts configuration
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.hyprland-scripts;
  
  # Create the change_sddm_wallpaper.sh script
  changeSddmWallpaperScript = pkgs.writeShellScriptBin "change_sddm_wallpaper" ''
    #!/usr/bin/env bash
    # Configuration
    SOURCE_IMAGE="$(realpath "$1")"
    SDDM_BG_PATH="/usr/share/sddm/themes/matugen/backgrounds/sddm.img"
    
    # Function to validate source image exists
    validate_source() {
        if [ -z "$SOURCE_IMAGE" ]; then
            echo "Usage: $0 /path/to/source/image"
            exit 1
        fi
        if [ ! -f "$SOURCE_IMAGE" ]; then
            echo "Error: Source image '$SOURCE_IMAGE' not found"
            exit 1
        fi
    }
    
    # Function to validate destination directory exists
    validate_destination() {
        DEST_DIR=$(dirname "$SDDM_BG_PATH")
        if [ ! -d "$DEST_DIR" ]; then
            echo "Creating destination directory: $DEST_DIR"
            mkdir -p "$DEST_DIR"
        fi
    }
    
    # Main execution
    main() {
        validate_source
        validate_destination
        echo "Copying image to SDDM themes directory..."
        if ! cp "$SOURCE_IMAGE" "$SDDM_BG_PATH"; then
            echo "Error: Failed to copy image"
            exit 1
        fi
    }
    
    main
  '';

  # Create the change_wallpaper.sh script
  changeWallpaperScript = pkgs.writeShellScriptBin "change_wallpaper" ''
    #!/usr/bin/env bash
    if ! pgrep -x "swww-daemon" > /dev/null; then
        swww-daemon --format xrgb &
    fi
    
    # Set the path to the wallpapers directory
    SOURCE_IMAGE="$(realpath "$1")"
    SDDM_BG_PATH="''${HOME}/.config/wallpaper.img"
    
    # Function to validate source image exists
    validate_source() {
        if [ -z "$SOURCE_IMAGE" ]; then
            echo "Usage: $0 /path/to/source/image"
            exit 1
        fi
        if [ ! -f "$SOURCE_IMAGE" ]; then
            echo "Error: Source image '$SOURCE_IMAGE' not found"
            exit 1
        fi
    }
    
    # Function to validate destination directory exists
    validate_destination() {
        DEST_DIR=$(dirname "$SDDM_BG_PATH")
        if [ ! -d "$DEST_DIR" ]; then
            echo "Creating destination directory: $DEST_DIR"
            mkdir -p "$DEST_DIR"
        fi
    }
    
    # Main execution
    main() {
        validate_source
        validate_destination
        echo "Copying image to wallpaper path..."
        if ! cp "$SOURCE_IMAGE" "$SDDM_BG_PATH"; then
            echo "Error: Failed to copy image"
            exit 1
        fi
        
        # Set wallpaper with swww
        swww img "$SOURCE_IMAGE" --transition-type grow --transition-pos 0.5,0.5 --resize fit
    }
    
    main
  '';

  # Create a script for wallpaper scrolling
  wallpaperScrollScript = pkgs.writeShellScriptBin "wallpaper_scroll" ''
    #!/usr/bin/env bash
    
    # Configuration
    WALLPAPER_DIR="''${HOME}/Pictures/Wallpapers"
    
    # Check if wallpaper directory exists
    if [ ! -d "$WALLPAPER_DIR" ]; then
      echo "Wallpaper directory not found. Creating it..."
      mkdir -p "$WALLPAPER_DIR"
      echo "Please add wallpapers to $WALLPAPER_DIR"
      exit 1
    fi
    
    # Count wallpapers
    WALLPAPERS=($WALLPAPER_DIR/*)
    WALLPAPER_COUNT=''${#WALLPAPERS[@]}
    
    if [ $WALLPAPER_COUNT -eq 0 ]; then
      echo "No wallpapers found in $WALLPAPER_DIR"
      exit 1
    fi
    
    # Choose random wallpaper
    RANDOM_INDEX=$((RANDOM % WALLPAPER_COUNT))
    SELECTED_WALLPAPER="''${WALLPAPERS[$RANDOM_INDEX]}"
    
    # Apply the wallpaper
    echo "Setting wallpaper: $SELECTED_WALLPAPER"
    ${changeWallpaperScript}/bin/change_wallpaper "$SELECTED_WALLPAPER"
  '';

  # Create script for screenshots
  screenshotScript = pkgs.writeShellScriptBin "screenshot" ''
    #!/usr/bin/env bash
    
    # Configuration
    SCREENSHOT_DIR="''${HOME}/Pictures/Screenshots"
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    SCREENSHOT_PATH="$SCREENSHOT_DIR/Screenshot_$TIMESTAMP.png"
    
    # Create directory if it doesn't exist
    mkdir -p "$SCREENSHOT_DIR"
    
    # Function for notification
    notify() {
      notify-send -i camera "Screenshot" "$1" -t 3000
    }
    
    # Take screenshot based on argument
    case "$1" in
      "--now")
        grim "$SCREENSHOT_PATH"
        notify "Full screenshot saved"
        ;;
      "--area")
        grim -g "$(slurp)" "$SCREENSHOT_PATH"
        notify "Area screenshot saved"
        ;;
      "--in5")
        notify "Taking screenshot in 5 seconds..."
        sleep 5
        grim "$SCREENSHOT_PATH"
        notify "Full screenshot saved"
        ;;
      "--in10")
        notify "Taking screenshot in 10 seconds..."
        sleep 10
        grim "$SCREENSHOT_PATH"
        notify "Full screenshot saved"
        ;;
      "--active")
        active_window=$(hyprctl activewindow | grep 'at:' | awk '{print $2}')
        if [ -n "$active_window" ]; then
          grim -g "$active_window" "$SCREENSHOT_PATH"
          notify "Active window screenshot saved"
        else
          notify "No active window detected"
        fi
        ;;
      "--swappy")
        grim -g "$(slurp)" - | swappy -f -
        notify "Screenshot edited with swappy"
        ;;
      *)
        echo "Usage: screenshot [--now|--area|--in5|--in10|--active|--swappy]"
        exit 1
        ;;
    esac
    
    # Copy to clipboard
    if [ -f "$SCREENSHOT_PATH" ]; then
      wl-copy < "$SCREENSHOT_PATH"
    fi
  '';

  # Volume control script
  volumeScript = pkgs.writeShellScriptBin "volume" ''
    #!/usr/bin/env bash
    
    # Configuration
    VOLUME_STEP=5
    MAX_VOLUME=150
    
    # Function for notification
    notify() {
      current_volume=$(pamixer --get-volume)
      notify-send -h string:x-canonical-private-synchronous:volume \
        -i audio-volume-high \
        -h int:value:$current_volume \
        "Volume" \
        "Current: $current_volume%" -t 1500
    }
    
    # Handle volume commands
    case "$1" in
      "--inc")
        pamixer --increase $VOLUME_STEP
        notify
        ;;
      "--dec")
        pamixer --decrease $VOLUME_STEP
        notify
        ;;
      "--toggle")
        pamixer --toggle-mute
        if pamixer --get-mute; then
          notify-send -h string:x-canonical-private-synchronous:volume \
            -i audio-volume-muted \
            "Volume" \
            "Muted" -t 1500
        else
          notify
        fi
        ;;
      "--toggle-mic")
        pamixer --default-source --toggle-mute
        if pamixer --default-source --get-mute; then
          notify-send -h string:x-canonical-private-synchronous:volume \
            -i microphone-sensitivity-muted \
            "Microphone" \
            "Muted" -t 1500
        else
          current_vol=$(pamixer --default-source --get-volume)
          notify-send -h string:x-canonical-private-synchronous:volume \
            -i microphone-sensitivity-high \
            -h int:value:$current_vol \
            "Microphone" \
            "Unmuted: $current_vol%" -t 1500
        fi
        ;;
      *)
        echo "Usage: volume [--inc|--dec|--toggle|--toggle-mic]"
        exit 1
        ;;
    esac
  '';

  # Keybinds hint script
  keybindsHintScript = pkgs.writeShellScriptBin "keybinds_hint" ''
    #!/usr/bin/env bash
    
    # Display a notification with common keybindings
    notify-send "Hyprland Keybindings" "
    <b>Super + Return</b>: Terminal
    <b>Super + Q</b>: Close window
    <b>Super + Space</b>: App launcher
    <b>Super + F</b>: Toggle floating
    <b>Super + B</b>: Launch browser
    <b>Super + V</b>: Clipboard history
    <b>Alt + Return</b>: Fullscreen
    <b>Super + R</b>: Random wallpaper
    <b>Super + Print</b>: Screenshot
    <b>Super + W</b>: Config selector
    <b>Super + [1-9]</b>: Switch workspace
    <b>Super + Shift + [1-9]</b>: Move window to workspace
    <b>Super + H/L</b>: Navigate workspaces
    <b>Super + Arrows</b>: Swap windows
    <b>Super + Shift + H/J/K/L</b>: Resize window
    " -t 10000
  '';

in {
  options.programs.hyprland-scripts = {
    enable = mkEnableOption "Enable Hyprland scripts";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      # Add the scripts to the system packages
      changeSddmWallpaperScript
      changeWallpaperScript
      wallpaperScrollScript
      screenshotScript
      volumeScript
      keybindsHintScript
      
      # Add dependencies for the scripts
      pkgs.matugen
      pkgs.swww
      pkgs.grim
      pkgs.slurp
      pkgs.wl-clipboard
      pkgs.pamixer
      pkgs.libnotify
    ];

    # Create a directory structure in /etc/hyprland
    environment.etc."hyprland/scripts/change_sddm_wallpaper".source = "${changeSddmWallpaperScript}/bin/change_sddm_wallpaper";
    environment.etc."hyprland/scripts/change_wallpaper".source = "${changeWallpaperScript}/bin/change_wallpaper";
    environment.etc."hyprland/scripts/wallpaper_scroll".source = "${wallpaperScrollScript}/bin/wallpaper_scroll";
    environment.etc."hyprland/scripts/screenshot".source = "${screenshotScript}/bin/screenshot";
    environment.etc."hyprland/scripts/volume".source = "${volumeScript}/bin/volume";
    environment.etc."hyprland/scripts/keybinds_hint".source = "${keybindsHintScript}/bin/keybinds_hint";

    # Create example matugen config files
    environment.etc."hyprland/matugen/wallpaper_config.toml".text = ''
      # Matugen wallpaper config
      
      # Output paths
      output_file = "~/.config/hypr/colors.conf"
      
      # Material theme scheme to use
      # tonal_spot, spritz, vibrant, expressive, rainbow, fruit_salad, content, muted, fidelity
      scheme = "vibrant"
      
      # Format using format strings
      [formats]
      "$background = {surface.hex}"= true
      "$foreground = {surface.hex}"= true
      "$shadow = {shadow.rgb_float}66"= true
      "$shadow-inactive = {shadow.rgb_float}66"= true
      "$border_color_active = {primary.hex}FF"= true
      "$border_color_inactive = {surface.hex}66"= true
      
      "$primary={primary.hex}"= true
      "$primary-fixed={primary-fixed.hex}"= true
      "$primary-fixed-dim={primary-fixed-dim.hex}"= true
      "$on-primary={on-primary.hex}"= true
      "$on-primary-fixed={on-primary-fixed.hex}"= true
      "$on-primary-fixed-variant={on-primary-fixed-variant.hex}"= true
      "$primary-container={primary-container.hex}"= true
      "$on-primary-container={on-primary-container.hex}"= true
      "$secondary={secondary.hex}"= true
      "$secondary-fixed={secondary-fixed.hex}"= true
      "$secondary-fixed-dim={secondary-fixed-dim.hex}"= true
      "$on-secondary={on-secondary.hex}"= true
      "$on-secondary-fixed={on-secondary-fixed.hex}"= true
      "$on-secondary-fixed-variant={on-secondary-fixed-variant.hex}"= true
      "$secondary-container={secondary-container.hex}"= true
      "$on-secondary-container={on-secondary-container.hex}"= true
      "$tertiary={tertiary.hex}"= true
      "$tertiary-fixed={tertiary-fixed.hex}"= true
      "$tertiary-fixed-dim={tertiary-fixed-dim.hex}"= true
      "$on-tertiary={on-tertiary.hex}"= true
      "$on-tertiary-fixed={on-tertiary-fixed.hex}"= true
      "$on-tertiary-fixed-variant={on-tertiary-fixed-variant.hex}"= true
      "$tertiary-container={tertiary-container.hex}"= true
      "$on-tertiary-container={on-tertiary-container.hex}"= true
      "$error={error.hex}"= true
      "$on-error={on-error.hex}"= true
      "$error-container={error-container.hex}"= true
      "$on-error-container={on-error-container.hex}"= true
      "$surface={surface.hex}"= true
      "$on-surface={on-surface.hex}"= true
      "$on-surface-variant={on-surface-variant.hex}"= true
      "$outline={outline.hex}"= true
      "$outline-variant={outline-variant.hex}"= true
      "$shadow={shadow.hex}"= true
      "$scrim={scrim.hex}"= true
      "$inverse-surface={inverse-surface.hex}"= true
      "$inverse-on-surface={inverse-on-surface.hex}"= true
      "$inverse-primary={inverse-primary.hex}"= true
      "$surface-dim={surface-dim.hex}"= true
      "$surface-bright={surface-bright.hex}"= true
      "$surface-container-lowest={surface-container-lowest.hex}"= true
      "$surface-container-low={surface-container-low.hex}"= true
      "$surface-container={surface-container.hex}"= true
      "$surface-container-high={surface-container-high.hex}"= true
      "$surface-container-highest={surface-container-highest.hex}"= true
      "$background={background.hex}"= true
      "$on-background={on-background.hex}"= true
    '';

    environment.etc."hyprland/matugen/sddm_config.toml".text = ''
      # Matugen SDDM config
      
      # Material theme scheme to use
      # tonal_spot, spritz, vibrant, expressive, rainbow, fruit_salad, content, muted, fidelity
      scheme = "vibrant"
      
      # Output paths for SDDM theme
      output_file = "/usr/share/sddm/themes/matugen/theme.conf"
      
      # Format using format strings
      [formats]
      "accent.color: {primary-container.hex}"= true
      "background.color: {background.hex}"= true
      "foreground.color: {on-background.hex}"= true
      "selection.color: {primary.hex}"= true
    '';

    # Create an activation script to initialize directories
    system.activationScripts.hyprlandScriptsSetup = ''
      mkdir -p /etc/hyprland/scripts
      mkdir -p $HOME/.config/matugen
      
      # Copy matugen config if it doesn't exist
      if [ ! -f $HOME/.config/matugen/wallpaper_config.toml ]; then
        cp /etc/hyprland/matugen/wallpaper_config.toml $HOME/.config/matugen/
      fi
      
      if [ ! -f $HOME/.config/matugen/sddm_config.toml ]; then
        cp /etc/hyprland/matugen/sddm_config.toml $HOME/.config/matugen/
      fi
      
      # Create screenshots and wallpapers directories
      mkdir -p $HOME/Pictures/Screenshots
      mkdir -p $HOME/Pictures/Wallpapers
    '';
  };
}
