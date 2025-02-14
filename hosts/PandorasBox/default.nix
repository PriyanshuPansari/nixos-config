{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
      networking.hostName = "PandorasBox"; # Define your hostname.

}
