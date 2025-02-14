{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
      networking.hostName = "PandorasBox"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.undead = {
    isNormalUser = true;
    description = "PriyanshuPansari";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [];
  };


  # Enable automatic login for the user.
  services.getty.autologinUser = "undead";
}
