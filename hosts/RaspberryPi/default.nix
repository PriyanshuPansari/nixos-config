{ config, pkgs, ... }:  # <-- Add function parameters at the top
{
  imports = [
    # ./hardware-configuration.nix
  ];

  networking.hostName = "RaspberryPi";
  #
  # # Enable Zsh system-wide
  # environment.systemPackages = [ pkgs.zsh ];  # <-- Add this line
  # programs.zsh.enable = true;  # <-- Optional but recommended

  # User configuration
  users.users.dev = {
    isNormalUser = true;
    description = "dev";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;  # This is correct
  };
programs.zsh.enable = true;
  # Automatic login
  services.getty.autologinUser = "dev";
}
