# Hyprland scripts module
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.my-hyprland;
in
{
  config = mkIf cfg.enable {
    # Create scripts in derivations
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "hyprland-screenshot" ''
        #!/usr/bin/env bash

        ## Script to take screenshots with grim, slurp and swappy

        time=$(date +%Y-%m-%d-%H-%M-%S)
        dir="$HOME/Pictures/Screenshots"
        file="Screenshot_''${time}.png"

        # Check if the dir exists, if not, create it
        [ ! -d "$dir" ] && mkdir -p "$dir"

        # Screenshot area selection
        if [[ "$1" == "--area" ]]; then
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | tee "$dir/$file" | ${pkgs.wl-clipboard}/bin/wl-copy
          ${pkgs.libnotify}/bin/notify-send "Screenshot Saved" "Area screenshot saved & copied to clipboard"

        # Screenshot current active window
        elif [[ "$1" == "--active" ]]; then
          active_window=$(${pkgs.hyprland}/bin/hyprctl activewindow | grep 'at:' | awk '{print $2}')
          ${pkgs.grim}/bin/grim -g "$active_window" - | tee "$dir/$file" | ${pkgs.wl-clipboard}/bin/wl-copy
          ${pkgs.libnotify}/bin/notify-send "Screenshot Saved" "Active window screenshot saved & copied to clipboard"

        # Screenshot current screen
        elif [[ "$1" == "--now" ]]; then
          ${pkgs.grim}/bin/grim - | tee "$dir/$file" | ${pkgs.wl-clipboard}/bin/wl-copy
          ${pkgs.libnotify}/bin/notify-send "Screenshot Saved" "Screenshot saved & copied to clipboard"

        # Screenshot in 5 seconds
        elif [[ "$1" == "--in5" ]]; then
          ${pkgs.libnotify}/bin/notify-send "Screenshot Timer" "Taking screenshot in 5 seconds"
          sleep 5
          ${pkgs.grim}/bin/grim - | tee "$dir/$file" | ${pkgs.wl-clipboard}/bin/wl-copy
          ${pkgs.libnotify}/bin/notify-send "Screenshot Saved" "Screenshot saved & copied to clipboard"

        # Screenshot in 10 seconds
        elif [[ "$1" == "--in10" ]]; then
          ${pkgs.libnotify}/bin/notify-send "Screenshot Timer" "Taking screenshot in 10 seconds"
          sleep 10
          ${pkgs.grim}/bin/grim - | tee "$dir/$file" | ${pkgs.wl-clipboard}/bin/wl-copy
          ${pkgs.libnotify}/bin/notify-send "Screenshot Saved" "Screenshot saved & copied to clipboard"

        # Use swappy to edit screenshot
        elif [[ "$1" == "--swappy" ]]; then
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -
          ${pkgs.libnotify}/bin/notify-send "Screenshot Saved" "Screenshot saved & copied to clipboard"

        # Help message
        else
          echo "Available Options:"
          echo "  --area      - Take screenshot of an area"
          echo "  --active    - Take screenshot of the active window"
          echo "  --now       - Take screenshot now"
          echo "  --in5       - Take screenshot in 5 seconds"
          echo "  --in10      - Take screenshot in 10 seconds"
          echo "  --swappy    - Use swappy to edit the screenshot"
        fi
      '')

      (pkgs.writeShellScriptBin "hyprland-volume" ''
        #!/usr/bin/env bash

        ## Script to manage audio volume

        # Get Volume
        get_volume() {
          volume=$(${pkgs.pamixer}/bin/pamixer --get-volume)
          echo "$volume"
        }

        # Notify
        notify_user() {
          ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "Volume : $(get_volume)%"
        }

        # Increase Volume
        inc_volume() {
          ${pkgs.pamixer}/bin/pamixer -i 5 && notify_user
        }

        # Decrease Volume
        dec_volume() {
          ${pkgs.pamixer}/bin/pamixer -d 5 && notify_user
        }

        # Toggle Mute
        toggle_mute() {
          if [ "$(${pkgs.pamixer}/bin/pamixer --get-mute)" == "false" ]; then
            ${pkgs.pamixer}/bin/pamixer -m && ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "Volume Muted"
          else
            ${pkgs.pamixer}/bin/pamixer -u && ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "Volume : $(get_volume)%"
          fi
        }

        # Toggle Mic
        toggle_mic() {
          if [ "$(${pkgs.pamixer}/bin/pamixer --default-source --get-mute)" == "false" ]; then
            ${pkgs.pamixer}/bin/pamixer --default-source -m && ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "Microphone Muted"
          else
            ${pkgs.pamixer}/bin/pamixer --default-source -u && ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "Microphone Activated"
          fi
        }

        # Execute accordingly
        if [[ "$1" == "--inc" ]]; then
          inc_volume
        elif [[ "$1" == "--dec" ]]; then
          dec_volume
        elif [[ "$1" == "--toggle" ]]; then
          toggle_mute
        elif [[ "$1" == "--toggle-mic" ]]; then
          toggle_mic
        else
          echo "Available Options: --inc, --dec, --toggle, --toggle-mic"
        fi
      '')

      (pkgs.writeShellScriptBin "hyprland-wallpaper" ''
        #!/usr/bin/env bash

        ## Script to change wallpapers with swww

        wallpaper_dir="$HOME/Pictures/Wallpapers"

        # Check if the directory exists
        if [ ! -d "$wallpaper_dir" ]; then
          mkdir -p "$wallpaper_dir"
          ${pkgs.libnotify}/bin/notify-send "Wallpaper Directory" "Created $wallpaper_dir"
          exit 1
        fi

        # Get a random wallpaper
        wallpaper=$(find "$wallpaper_dir" -type f | shuf -n 1)

        # Apply the wallpaper with swww
        ${pkgs.swww}/bin/swww img "$wallpaper" --transition-type center --transition-step 30

        # Optional: Generate color scheme from wallpaper
        if command -v ${pkgs.matugen}/bin/matugen &> /dev/null; then
          ${pkgs.matugen}/bin/matugen "$wallpaper"
        fi

        ${pkgs.libnotify}/bin/notify-send "Wallpaper Changed" "Applied: $(basename "$wallpaper")"
      '')
    ];
  };
}
