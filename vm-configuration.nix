{ pkgs, inputs, ... }:
{
  # Enable flakes and nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Import the Jovian-NixOS module
  imports = [
    inputs.jovian-nixos.nixosModules.default
  ];

  # Basic boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # User configuration
  users.users.gamer = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
    initialPassword = "password";
  };

  # Allow unfree packages (required for Steam)
  nixpkgs.config.allowUnfree = true;

  # Jovian Steam configuration
  jovian = {
    steam = {
      enable = true;
      user = "gamer";
      desktopSession = "hyprland";
      autoStart = true;
    };
  };

  # Graphics support
  hardware.graphics.enable = true;

  # Audio support through pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # # Enable Hyprland
  programs.hyprland.enable = true;
  # programs.xwayland.enable = true;

  # XDG Portal for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # System state version
  system.stateVersion = "24.11";
}
