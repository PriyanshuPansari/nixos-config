{ config, pkgs, ... }:

{
	wayland.windowManager.hyprland = {
		enable = true;
		systemd.enable = false;
		configType = "hyprlang";

		settings = {
			env = [
   			   "HYPRSHOT_DIR,/home/undead/Pictures/Screenshots"
 			   ];
			source = [" ~/.config/hypr/monitors.conf"];
			input = {
				follow_mouse = 1;
				touchpad.natural_scroll = false;

			};
			general = {
				gaps_in = 0;
				gaps_out = 0;
				border_size = 1;
			};

			animations.enabled = false;

			gesture = "3, horizontal, workspace";

			"$mainMod" = "SUPER";
			"$shiftMod" = "SUPER SHIFT";
			exec-once =[ "uwsm app -- syncthing &"
				"wl-paste --type text --watch cliphist store"
				"wl-paste --type image --watch cliphist store"
				];

			bind = [
				"$mainMod, return, exec, uwsm app -- ghostty"
				 "$mainMod, V, exec, cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"
				 "$mainMod, G, togglegroup,"
				 "$mainMod, a, exec,ani-cli --rofi"
				 "$shiftMod, a, exec,ani-cli --rofi -c"
				 "$mainMod, right,changegroupactive,r"
				 "$mainMod, left,changegroupactive,l"
					",PRINT,exec,hyprshot -m output"
					"$mainMod, PRINT, exec, hyprshot -m window"
					"$shiftMod,PRINT,exec, hyprshot -m region" 
					"$mainMod, Q, killactive,"
					"$mainMod ALT, DELETE, exit,"
					"$mainMod ALT, RETURN, fullscreen"
					"$mainMod, E, exec, ghostty -e yazi"
					"$mainMod SHIFT, E, exec, ghostty -e sudo yazi"
					"$mainMod, F, togglefloating,"
					"$mainMod, space, exec, uwsm app -- rofi -show drun"
					"$mainMod, h, movefocus, l"
					"$mainMod, j, movefocus, d"
					"$mainMod, k, movefocus, u"
					"$mainMod, l, movefocus, r"
					"$mainMod SHIFT, h, workspace, r-1"
					"$mainMod SHIFT, l, workspace, r+1"
					"$mainMod SHIFT, k, focusmonitor, -1"
					"$mainMod SHIFT, j, focusmonitor, +1"
					"$mainMod, 1, workspace, 1"
					"$mainMod, 2, workspace, 2"
					"$mainMod, 3, workspace, 3"
					"$mainMod, 4, workspace, 4"
					"$mainMod, 5, workspace, 5"
					"$mainMod, 6, workspace, 6"
					"$mainMod, 7, workspace, 7"
					"$mainMod, 8, workspace, 8"
					"$mainMod, 9, workspace, 9"

					"$mainMod SHIFT, 1, movetoworkspace, 1"
					"$mainMod SHIFT, 2, movetoworkspace, 2"
					"$mainMod SHIFT, 3, movetoworkspace, 3"
					"$mainMod SHIFT, 4, movetoworkspace, 4"
					"$mainMod SHIFT, 5, movetoworkspace, 5"
					"$mainMod SHIFT, 6, movetoworkspace, 6"
					"$mainMod SHIFT, 7, movetoworkspace, 7"
					"$mainMod SHIFT, 8, movetoworkspace, 8"
					"$mainMod SHIFT, 9, movetoworkspace, 9"

					"$mainMod, S, togglespecialworkspace, magic"
					"$mainMod SHIFT, S, movetoworkspace, special:magic"
					];
			bindm =[

				"$mainMod, mouse:272, movewindow"
					"$mainMod, mouse:273, resizewindow"

			];
			bindl =[
				",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
					",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
					",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
					",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
					",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
					",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
			];
		};
	};
}

