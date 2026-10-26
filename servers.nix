{ config, ... }:

let
	secret = owner: {
		inherit owner;
		restartUnits = [ "${owner}.service" ];
	};
	ph = config.sops.placeholder;
in
{
	sops = {
		defaultSopsFile = ./secrets/servers.yaml;
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
		host = "0.0.0.0";
		openFirewall = true;
		environmentFile = config.sops.templates."fiction-tracker.env".path;
		environment = {
			FICTION_TRACKER_BASE_URL = "http://192.168.1.8:8765";
			FICTION_TRACKER_POLL_MINUTES = "45";
		};
	};

	services.paper-server = {
		enable = true;
		host = "0.0.0.0";
		openFirewall = true;
		environmentFile = config.sops.templates."paper-server.env".path;
		environment.PAPER_SERVER_MAX_UPLOAD_MB = "200";
	};

	# Loopback only: Site Shelf has no login of its own.
	services.site-shelf.enable = true;
}
