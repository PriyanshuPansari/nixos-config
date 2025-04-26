# Ghostty Terminal configuration
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.my-ghostty;
in
{
  imports = [
    ./colors.nix  # Import colors configuration
  ];

  options.programs.my-ghostty = {
    enable = mkEnableOption "my ghostty terminal configuration";
  };

  config = mkIf cfg.enable {
    # Install ghostty
    environment.systemPackages = with pkgs; [
      ghostty
    ];

    # Home-manager configuration for the undead user
    home-manager.users.undead = { pkgs, ... }: {
      # Add Ghostty to the environment variables
      home.sessionVariables = {
        TERMINAL = "ghostty";
      };


      # Create a desktop entry for Ghostty
      xdg.desktopEntries.ghostty = {
        name = "Ghostty";
        comment = "GPU-accelerated terminal emulator";
        exec = "ghostty";
        icon = "terminal";
        type = "Application";
        categories = [ "System" "TerminalEmulator" ];
        terminal = false;
      };
    };
  };
}
