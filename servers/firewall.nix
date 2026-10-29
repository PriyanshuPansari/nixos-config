{ config, ... }:

{
	networking.nftables.enable = true;

	networking.firewall = {
		enable = true;
		interfaces.tailscale0.allowedTCPPorts = [ 22 ];
		extraInputRules = ''
			ip saddr ${config.my.lan.subnet} tcp dport 22 accept
		'';
	};
}
