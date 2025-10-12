{ config, pkgs, ...}:
{
	home.username = "undead";
	home.homeDirectory = "/home/undead";

	imports = [
		./programs/hyprland/default.nix
	];
	nixpkgs.config.allowUnfree = true;
	programs.home-manager.enable = true;
	services.hyprpaper = {
		enable = true;
		settings = {
# Example config, adjust paths
			preload = [ "/home/undead/wallpapers/default.jpeg" ];
			wallpaper = [
				",/home/undead/wallpapers/default.jpeg"
			];
		};
	};	home.packages = with pkgs; [
	tmux
	cliphist
	google-chrome
	wl-clipboard
	steam
	openconnect
	spotify
	hyprshot
		clipse
		fzf
		discord
		qutebrowser
		syncthing
		ghostty
		rofi
		yazi
		nwg-displays
		firefox
		obsidian
		vscode-fhs
# quickshell
		zed-editor-fhs
		# widevine-cdm
		brightnessctl
	];
	programs.zsh = {
		enable =true;
	};

	home.stateVersion = "25.05";
}

