{ config, lib, pkgs, ... }:

let
	# HTTPS port on the tailnet -> loopback app port. :443 is kept for consume.
	serve = {
		"8444" = 8765; # fiction-tracker
		"8446" = 8877; # paper-server (until it merges into consume)
	};
in
{
	options.my.tailnet = lib.mkOption {
		type = lib.types.str;
		readOnly = true;
		description = "hope's MagicDNS name.";
	};

	config = {
		my.tailnet = "hope.tail3b1817.ts.net";

		services.tailscale = {
			enable = true;
			openFirewall = true;
		};

		# The NixOS firewall runs on nftables; keep tailscaled from adding iptables rules.
		systemd.services.tailscaled.environment.TS_DEBUG_FIREWALL_MODE = "nftables";

		# Declarative `tailscale serve`: HTTPS with a Let's Encrypt cert, tailnet only.
		# Not named "tailscale-serve": nixpkgs' services.tailscale.serve owns that unit.
		systemd.services.tailscale-serve-node = {
			description = "Expose loopback apps on the tailnet";
			after = [ "tailscaled.service" ];
			wants = [ "tailscaled.service" ];
			wantedBy = [ "multi-user.target" ];
			restartTriggers = [ (builtins.toJSON serve) ];
			path = [ config.services.tailscale.package pkgs.jq ];
			serviceConfig = {
				Type = "oneshot";
				RemainAfterExit = true;
			};
			script = ''
				for i in $(seq 90); do
					tailscale status --json | jq -e '.BackendState == "Running"' >/dev/null && break
					sleep 2
				done
				tailscale serve reset
				${lib.concatStrings (lib.mapAttrsToList (https: port: ''
					tailscale serve --bg --https=${https} http://127.0.0.1:${toString port}
				'') serve)}
			'';
		};
	};
}
