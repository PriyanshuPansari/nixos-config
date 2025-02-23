{ config, pkgs, ... }:  # <-- Add function parameters at the top
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "PandorasBox";
  #
  # # Enable Zsh system-wide
  # environment.systemPackages = [ pkgs.zsh ];  # <-- Add this line
  # programs.zsh.enable = true;  # <-- Optional but recommended

  # User configuration
  users.users.undead = {
    isNormalUser = true;
    description = "PriyanshuPansari";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;  # This is correct
  };

  # Automatic login
  services.getty.autologinUser = "undead";
}
