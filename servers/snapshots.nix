{ lib, pkgs, ... }:

# Nightly consistent SQLite snapshots, kept 14 days. Local only: this guards against
# corruption and bad migrations, not disk failure. Off-site restic comes later.
let
	dbs = {
		fiction-tracker = "/var/lib/fiction-tracker/tracker.sqlite3";
		paper-server = "/var/lib/paper-server/paper-server.sqlite3";
	};
	sqlite = "${pkgs.sqlite}/bin/sqlite3";
	dir = "/var/backup/sqlite";
in
{
	systemd.tmpfiles.rules = [ "d ${dir} 0700 root root -" ];

	systemd.services.sqlite-snapshot = {
		description = "Snapshot SQLite databases";
		serviceConfig = {
			Type = "oneshot";
			IOSchedulingClass = "idle";
			Nice = 10;
		};
		script = ''
			set -eu
			stamp=$(date +%F)
			${lib.concatStrings (lib.mapAttrsToList (name: path: ''
				test -s ${path} || { echo "missing ${path}"; exit 1; }
				${sqlite} ${path} ".backup ${dir}/${name}-$stamp.db"
				test "$(${sqlite} ${dir}/${name}-$stamp.db 'PRAGMA integrity_check')" = ok
			'') dbs)}
			find ${dir} -name '*.db' -mtime +14 -delete
		'';
	};

	systemd.timers.sqlite-snapshot = {
		wantedBy = [ "timers.target" ];
		timerConfig = {
			OnCalendar = "03:30";
			Persistent = true;
		};
	};
}
