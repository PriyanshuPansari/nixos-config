{ pkgs, lib, ... }: {
      # bcm2711 for rpi 3, 3+, 4, zero 2 w
      # bcm2712 for rpi 5
      # See the docs at:
      # https://www.raspberrypi.com/documentation/computers/linux_kernel.html#native-build-configuration
      raspberry-pi-nix.board = "bcm2712";
      time.timeZone = "Asia/Kolkata";

      users.users.root = {
        initialPassword = "root";
      };
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.dev = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        initialPassword = "dev";
      };

      networking = {
        hostName = "RaspberryPi";
      };
      environment.systemPackages = with pkgs; [
        emacs
        git
        wget
      ];
      services.openssh = {
        enable = true;
      };
      system.stateVersion = "24.05";
    }
