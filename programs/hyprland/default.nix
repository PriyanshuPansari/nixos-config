# Main Hyprland module
{ config, lib, pkgs, ... }:

{
  imports = [
    ./config.nix  # The main Hyprland configuration
    ./scripts.nix # The Hyprland scripts
  ];

  options.programs.my-hyprland = {
    enable = lib.mkEnableOption "my Hyprland configuration";
    
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.hyprland;
      description = "The Hyprland package to use";
    };
  };

  # No circular reference in the config section
  config = lib.mkIf config.programs.my-hyprland.enable {
    # We only enable the system-level Hyprland here
    programs.hyprland.enable = true;
  };
}
