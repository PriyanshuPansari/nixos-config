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
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [];
  };
  services.getty.autologinUser = "pandora";

}
