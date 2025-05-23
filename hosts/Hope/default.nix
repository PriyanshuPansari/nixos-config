{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
      networking.hostName = "Hope"; # Define your hostname.

  users.users.pandora = {
    isNormalUser = true;
    description = "PriyanshuPansari";
    # packages = with pkgs; [];
    extraGroups = [ "networkmanager" "wheel" "docker" "gamemode" ];
  };
    services.getty.autologinUser = "pandora";

}
