#!/usr/bin/env bash
# One-time cutover from the old user services to the declarative system services.
# Run as undead (not with sudo); it asks for sudo where needed.
# Original data in ~/<project>/data is left untouched as a backup.
set -euo pipefail

FLAKE=/home/undead/.nixos-config
SERVICES=(fiction-tracker paper-server site-shelf)

# The old user services hold ports 8765/8877; bring them back if the switch fails.
systemctl --user disable --now fiction-tracker.service paper-server.service 2>/dev/null || true
trap 'echo "Switch failed; restarting old user services." >&2; systemctl --user enable --now fiction-tracker.service paper-server.service' ERR

sudo nixos-rebuild switch --flake "$FLAKE#hope"
trap - ERR

# Services start on switch with empty state; replace it with the existing data.
sudo systemctl stop "${SERVICES[@]}"
for s in "${SERVICES[@]}"; do
	sudo find "/var/lib/$s" -mindepth 1 -delete
	sudo cp -a "/home/undead/$s/data/." "/var/lib/$s/"
	sudo rm -f "/var/lib/$s/.gitkeep"
	sudo chown -R "$s:$s" "/var/lib/$s"
	sudo chmod 700 "/var/lib/$s"
done
sudo systemctl start "${SERVICES[@]}"

rm -f /home/undead/.config/systemd/user/fiction-tracker.service \
	/home/undead/.config/systemd/user/paper-server.service
systemctl --user daemon-reload

sleep 3
for p in 8765 8877 8899; do
	printf '%s: ' "$p"
	curl -sf -m3 "http://127.0.0.1:$p/health" || printf 'NOT HEALTHY'
	echo
done
systemctl --no-pager --lines=0 status "${SERVICES[@]}"
