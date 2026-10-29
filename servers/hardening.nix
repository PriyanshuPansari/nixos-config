{ ... }:

{
	# Keys only; port 22 is opened per interface in firewall.nix, never globally
	# (hope has public IPv6 addresses).
	services.openssh = {
		enable = true;
		openFirewall = false;
		settings = {
			PasswordAuthentication = false;
			KbdInteractiveAuthentication = false;
			PermitRootLogin = "no";
		};
	};

	users.users.undead.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElhsq+eAcazdG4aenHTRvGi2PhrIJvLwjWpkfMSRE69 incre-windows-to-hope"
	];

	# Root needs a password: anything running as undead (agents included) must not get silent root.
	security.sudo.wheelNeedsPassword = true;

	zramSwap = {
		enable = true;
		algorithm = "zstd";
		memoryPercent = 50;
	};

	# hope is also the desktop: cap what the self-hosted services can take from it.
	systemd.slices.server.sliceConfig = {
		MemoryHigh = "3G";
		CPUWeight = 20;
	};
}
