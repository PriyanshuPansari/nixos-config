{ lib, ... }:

# The only place LAN addresses live. Back each one with a DHCP reservation on the router.
{
	options.my.lan = lib.mkOption {
		type = lib.types.attrsOf lib.types.str;
		readOnly = true;
	};

	config.my.lan = {
		subnet = "192.168.1.0/24";
		router = "192.168.1.1";
		hope = "192.168.1.20"; # wlp3s0 dc:a2:66:4c:2a:3b
	};
}
