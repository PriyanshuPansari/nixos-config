{ config, ... }:

let
	secret = owner: {
		inherit owner;
		restartUnits = [ "${owner}.service" ];
	};
	ph = config.sops.placeholder;

	# Services that fetch untrusted URLs must not reach the router or LAN (SSRF, DNS
	# rebinding). DNS still works: glibc resolves through nscd's socket.
	sandboxed = {
		Slice = "server.slice";
		IPAddressDeny = [
			"10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16" "100.64.0.0/10"
			"169.254.0.0/16" "fc00::/7" "fe80::/10"
		];
	};
in
{
	sops = {
		defaultSopsFile = ../secrets/servers.yaml;
		age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

		secrets = {
			"fiction-tracker/username" = secret "fiction-tracker";
			"fiction-tracker/password" = secret "fiction-tracker";
			"fiction-tracker/feed-token" = secret "fiction-tracker";
			"paper-server/device-token" = secret "paper-server";
		};

		templates."fiction-tracker.env" = {
			owner = "fiction-tracker";
			restartUnits = [ "fiction-tracker.service" ];
			content = ''
				FICTION_TRACKER_USERNAME=${ph."fiction-tracker/username"}
				FICTION_TRACKER_PASSWORD=${ph."fiction-tracker/password"}
				FICTION_TRACKER_FEED_TOKEN=${ph."fiction-tracker/feed-token"}
			'';
		};

		templates."paper-server.env" = {
			owner = "paper-server";
			restartUnits = [ "paper-server.service" ];
			content = ''
				PAPER_SERVER_DEVICE_TOKEN=${ph."paper-server/device-token"}
			'';
		};
	};

	services.fiction-tracker = {
		enable = true;
		host = "127.0.0.1";
		openFirewall = false;
		environmentFile = config.sops.templates."fiction-tracker.env".path;
		environment = {
			FICTION_TRACKER_BASE_URL = "https://${config.my.tailnet}:8444";
			FICTION_TRACKER_POLL_MINUTES = "45";
		};
	};

	services.paper-server = {
		enable = true;
		host = "127.0.0.1";
		openFirewall = false;
		environmentFile = config.sops.templates."paper-server.env".path;
		environment.PAPER_SERVER_MAX_UPLOAD_MB = "200";
	};

	# Retired: it never held data. Its feed code moves into consume in Phase 4.
	services.site-shelf.enable = false;

	# Reachable only through tailscale serve on loopback (IPAddressDeny also blocks inbound LAN).
	systemd.services.fiction-tracker.serviceConfig = sandboxed;
	systemd.services.paper-server.serviceConfig = sandboxed;
}
