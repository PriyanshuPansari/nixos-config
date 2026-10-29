{ config, pkgs, ... }:

# Alerts go to an ntfy.sh topic (random name in sops); subscribe to it in the ntfy app.
# Messages carry only the unit/device name, never log lines: ntfy.sh topics are public
# to anyone who learns the name.
let
	topicFile = config.sops.secrets."ntfy/topic".path;

	ntfy = pkgs.writeShellScript "ntfy" ''
		# usage: ntfy <title> <message>
		# The URL goes through curl's stdin config so the topic never appears in argv.
		printf 'url = "https://ntfy.sh/%s"\n' "$(cat ${topicFile})" |
			exec ${pkgs.curl}/bin/curl -K - -fsS -m 20 --retry 3 \
				-H "Title: $1" -H "Tags: warning" -d "$2"
	'';

	smartNotify = pkgs.writeShellScript "smartd-ntfy" ''
		exec ${ntfy} "hope: SMART warning on $SMARTD_DEVICE" "$SMARTD_FAILTYPE"
	'';
in
{
	sops.secrets."ntfy/topic" = { };

	# Add `OnFailure = [ "notify@%n.service" ]` to a unit to get alerted when it fails.
	systemd.services."notify@" = {
		description = "Send an ntfy alert that %i failed";
		serviceConfig.Type = "oneshot";
		scriptArgs = "%i";
		script = ''${ntfy} "hope: $1 failed" "Check: journalctl -u $1"'';
	};

	services.smartd = {
		enable = true;
		notifications.wall.enable = false;
		# Short self-test daily at 02:00, long test Saturdays at 03:00.
		defaults.autodetected = "-a -o on -s (S/../.././02|L/../../6/03) -m <nomailer> -M exec ${smartNotify}";
	};

	systemd.services = {
		fiction-tracker.unitConfig.OnFailure = [ "notify@%n.service" ];
		paper-server.unitConfig.OnFailure = [ "notify@%n.service" ];
		sqlite-snapshot.unitConfig.OnFailure = [ "notify@%n.service" ];
	};
}
