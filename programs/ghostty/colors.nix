# Theme configuration for Ghostty
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.my-ghostty;
in
{
  config = mkIf cfg.enable {
    home-manager.users.undead = { pkgs, ... }: {
      # Modify the main config to include theme import
      xdg.configFile."ghostty/config".text = ''
        # Ghostty configuration

        # UI preferences
        window-decoration = false
        window-padding-x = 10
        window-padding-y = 10
        
        # Background transparency
        background-opacity = 0.85
        
        # Font configuration
        font-family = "JetBrainsMono Nerd Font"
        font-size = 12
        
        shell-integration-features = no-cursor
        
        # Cursor settings
        cursor-style = block
        cursor-color = #7aa2f7
                # Tokyo Night theme for Ghostty

        # Special
        foreground = #c0caf5
        background = #1a1b26
        selection-foreground = #1a1b26
        selection-background = #c0caf5

        # Black
        palette = 0=#15161e
        palette = 8=#414868

        # Red
        palette = 1=#f7768e
        palette = 9=#f7768e

        # Green
        palette = 2=#9ece6a
        palette = 10=#9ece6a

        # Yellow
        palette = 3=#e0af68
        palette = 11=#e0af68

        # Blue
        palette = 4=#7aa2f7
        palette = 12=#7aa2f7

        # Magenta
        palette = 5=#bb9af7
        palette = 13=#bb9af7

        # Cyan
        palette = 6=#7dcfff
        palette = 14=#7dcfff

        # White
        palette = 7=#a9b1d6
        palette = 15=#c0caf5
        
      '';
    };
  };
}
