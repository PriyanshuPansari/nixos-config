# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, home-manager, nixpkgs-unstable, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
			home-manager.nixosModules.default
		];
	home-manager = {
		users.undead = import ./home.nix;
		backupFileExtension = "backup";
		useUserPackages = true;
	};
	nixpkgs.overlays = [
		(final: prev:
			let
				unstable = import nixpkgs-unstable {
					system = prev.stdenv.hostPlatform.system;
					config.allowUnfree = true;
				};
			in {
				inherit (unstable) codex claude-code;
			})
	];
	hardware.graphics={
	enable = true;
	enable32Bit = true;
	};
# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	nix.settings.experimental-features = ["nix-command" "flakes"];
	networking.hostName = "hope"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
	 	networking.networkmanager.enable = true;
		hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  settings = {
    General = {
      # Shows battery charge of connected devices on supported
      # Bluetooth adapters. Defaults to 'false'.
      Experimental = true;
      # When enabled other devices can connect faster to us, however
      # the tradeoff is increased power consumption. Defaults to
      # 'false'.
      FastConnectable = true;
    };
    Policy = {
      # Enable all controllers when they are found. This includes
      # adapters present on start as well as adapters that are plugged
      # in later on. Defaults to 'true'.
      AutoEnable = true;
    };
  };
};


# Set your time zone.
	time.timeZone = "Asia/Kolkata";

	xdg.portal = {
		enable = true;
		extraPortals = with pkgs;[
			xdg-desktop-portal-hyprland
		];
	};

# Select internationalisation properties.
	i18n.defaultLocale = "en_IN";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "en_IN";
		LC_IDENTIFICATION = "en_IN";
		LC_MEASUREMENT = "en_IN";
		LC_MONETARY = "en_IN";
		LC_NAME = "en_IN";
		LC_NUMERIC = "en_IN";
		LC_PAPER = "en_IN";
		LC_TELEPHONE = "en_IN";
		LC_TIME = "en_IN";
	};

# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};

# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.undead = {
		isNormalUser = true;
		description = "Priyanshu Pansari";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [];
		# Self-hosted servers run as system services (servers.nix); no user lingering needed.
		linger = false;
	};

# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
	environment.systemPackages = with pkgs; [
		neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
			git
#  wget
	];

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };
	programs.hyprland ={
		enable = true;
		withUWSM = true;
	};

# Run prebuilt dynamically linked binaries (e.g. the Claude CLI for remote sessions).
	programs.nix-ld.enable = true;

# List services that you want to enable:
	services.logind.settings.Login = {
		HandleLidSwitch = "ignore";
		HandleLidSwitchExternalPower = "ignore";
		HandleLidSwitchDocked = "ignore";
	};

# Enable the OpenSSH daemon.
  # OpenSSH is configured in servers/hardening.nix (keys only, LAN + tailnet).

# Open ports in the firewall.
# 8765 (fiction-tracker) and 8877 (paper-server) are opened via openFirewall in servers.nix.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.05"; # Did you read the comment?

}
