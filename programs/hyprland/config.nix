# Hyprland configuration module
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.my-hyprland;
in
{
  config = mkIf cfg.enable {
    # Enable Hyprland
    programs.hyprland = {
      enable = true;
      package = cfg.package;
      xwayland.enable = true;
    };

    # Home-manager configuration for the undead user
    home-manager.users.undead = { pkgs, ... }: {
      # Enable the home-manager module for Hyprland
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        
        settings = {
          # Monitor configuration
          monitor = [
            ",preferred,auto,auto"
            "eDP-1,1920x1080@144.00,0x0,1.0"
            "HDMI-A-1,1920x1080@100.00,0x-1080,1"
          ];

          # General configuration
          general = {
            gaps_in = 0;
            gaps_out = 2;
            border_size = 1;
            "col.active_border" = "rgba(bcc2ffFF)";
            "col.inactive_border" = "rgba(13131866)";
            resize_on_border = true;
            layout = "dwindle";
          };

          # Decoration settings
          decoration = {
            rounding = 1;
            active_opacity = 1.0;
            inactive_opacity = 0.9;
            
            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = "rgba(1a1a1aee)";
            };
            
            blur = {
              enabled = true;
              size = 3;
              passes = 1;
              vibrancy = 0.1696;
            };
          };

          # Animations
          animations = {
            enabled = true;
            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };

          # Layout settings
          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };

          master = {
            new_status = "master";
          };

          # Misc settings
          misc = {
            force_default_wallpaper = -1;
            disable_hyprland_logo = true;
          };

          # Input settings
          input = {
            kb_layout = "us";
            follow_mouse = 1;
            sensitivity = 0;
            touchpad = {
              natural_scroll = true;
            };
          };

          # Gestures
          gestures = {
            workspace_swipe = true;
          };

          # Device-specific settings
          device = [
            {
              name = "epic-mouse-v1";
              sensitivity = -0.5;
            }
          ];

          # Environment variables
          env = [
            "HYPRCURSOR_THEME,Bibata-Modern-Classic"
            "HYPRCURSOR_SIZE,24"
            "QT_QPA_PLATFORM,wayland:xcb"
            "QT_QPA_PLATFORMTHEME,qt6ct"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "QT_AUTO_SCREEN_SCALE_FACTOR,0"
            "MOZ_ENABLE_WAYLAND,1"
            "MOZ_DBUS_REMOTE,1"
            "LIBVA_DRIVER_NAME,nvidia"
            "XDG_SESSION_TYPE,wayland"
            "GBM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "NVD_BACKEND,direct"
            "ELECTRON_OZONE_PLATFORM_HINT,wayland"
          ];

          # Autostart applications
          exec-once = [
            "waybar &"
            "nm-applet --indicator &"
            "systemctl --user start hyprpolkitagent"
            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"
            "swww-daemon --format xrgb &"
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "hypridle &"
            "pypr &"
            "blueman-applet"
            "hyprctl setcursor Bibata-Modern-Classic 24"
          ];

          exec = [
            "gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'"
          ];

          # Window rules
          windowrulev2 = [
            "suppressevent maximize, class:.*"
            "bordersize 0, floating:0, onworkspace:w[tv1]"
            "rounding 0, floating:0, onworkspace:w[tv1]"
            "bordersize 0, floating:0, onworkspace:f[1]"
            "rounding 0, floating:0, onworkspace:f[1]"
            "noblur, floating:1"
            "noblur, class:.*, onworkspace:w[tv1]"
            "noblur, class:.*, onworkspace:f[1]"
            "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
            "syncfullscreen 0,class:(firefox)"
          ];

          # Workspace rules
          workspace = [
            "w[tv1], gapsout:0, gapsin:0"
            "f[1], gapsout:0, gapsin:0"
          ];

          # Key bindings
          "$mainMod" = "super"; # Windows key

          # Application bindings
          bind = [
            "$mainMod, Return, exec, ghostty"
            "$mainMod, Q, killactive,"
            "control alt, delete, exit,"
            "control alt, L, exec, hyprlock"
            "$mainMod, E, exec, ghostty yazi"
            "$mainMod, F, togglefloating,"
            "$mainMod, b, exec, qutebrowser"
            "$mainMod, Space, exec, rofi -show drun"
            "$mainMod, P, pseudo,"
            "$mainMod, i, togglesplit,"
            "SUPER, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
            "alt, return, fullscreen"
            "$mainMod alt, space, exec, ~/.config/rofi/rofi-desktop/scripts/rofi-desktop.sh -a"
            
            # Media and custom bindings
            "$mainMod, A, exec, ani-cli --rofi"
            "$mainMod shift, A, exec, ani-cli --rofi -c"
            "$mainMod, R, exec, hyprland-wallpaper"
            "$mainMod, W, exec, rofi -config ~/.config/rofi/config_select.rasi -show"
            "$mainMod, G, exec, rofi -config ~/.config/rofi/game.rasi -show"
            
            # Pyprland bindings
            "super SHIFT, Return, exec, pypr toggle term"
            "$mainMod, Z, exec, pypr zoom"
            "$mainMod, 316, exec, pypr zoom"
            
            # Screenshot bindings
            "$mainMod, Print, exec, hyprland-screenshot --now"
            "$mainMod SHIFT, Print, exec, hyprland-screenshot --area"
            "$mainMod CTRL, Print, exec, hyprland-screenshot --in5"
            "$mainMod CTRL SHIFT, Print, exec, hyprland-screenshot --in10"
            "ALT, Print, exec, hyprland-screenshot --active"
            "$mainMod SHIFT, S, exec, hyprland-screenshot --swappy"
            
            # Waybar toggle
            ", super_l, exec, pkill -SIGUSR1 waybar"
            "$mainMod alt, h, exec, ~/.config/hypr/scripts/keybinds_hint.sh"
            
            # Window focus and movement
            "$mainMod control, h, movefocus, l"
            "$mainMod control, l, movefocus, r"
            "$mainMod control, k, movefocus, u"
            "$mainMod control, j, movefocus, d"
            
            # Workspace switching
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"
            
            # Move windows to workspaces
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"
            
            # Window swapping and workspace movement
            "$mainMod SHIFT, l, movetoworkspace, e+1"
            "$mainMod SHIFT, h, movetoworkspace, e-1"
            "$mainMod, left, swapwindow, l"
            "$mainMod, right, swapwindow, r"
            "$mainMod, up, swapwindow, u"
            "$mainMod, down, swapwindow, d"
            
            # Special workspace
            "$mainMod, S, togglespecialworkspace, magic"
            "$mainMod SHIFT, S, movetoworkspace, special:magic"
            
            # Monitor focus and workspace navigation
            "$mainMod, j, focusmonitor, +1"
            "$mainMod, k, focusmonitor, -1"
            "$mainMod, h, workspace, m-1"
            "$mainMod, l, workspace, m+1"
            "$mainMod, tab, workspace, e+1"
            "$mainMod SHIFT, tab, workspace, e-1"
            
            # Mouse button workspace switching
            ", mouse:275, workspace, +1"
            ", mouse:276, workspace, -1"
            
            # Volume and brightness controls
            ", XF86AudioRaiseVolume, exec, hyprland-volume --inc"
            ", XF86AudioLowerVolume, exec, hyprland-volume --dec"
            ", XF86AudioMute, exec, hyprland-volume --toggle"
            ", XF86AudioMicMute, exec, hyprland-volume --toggle-mic"
            ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
            ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
            
            # Media controls
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPause, exec, playerctl play-pause"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioPrev, exec, playerctl previous"
          ];

          # Resizing bindings
          bindel = [
            "$mainMod SHIFT, l, resizeactive, 10 0"
            "$mainMod SHIFT, h, resizeactive, -10 0"
            "$mainMod SHIFT, k, resizeactive, 0 -10"
            "$mainMod SHIFT, j, resizeactive, 0 10"
            ", XF86AudioRaiseVolume, exec, hyprland-volume --inc"
            ", XF86AudioLowerVolume, exec, hyprland-volume --dec"
            ", XF86AudioMute, exec, hyprland-volume --toggle"
            ", XF86AudioMicMute, exec, hyprland-volume --toggle-mic"
            ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
            ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
          ];

          # Mouse bindings
          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];
        };

        # Extra configuration for HyprLand that's not covered by the settings above
        extraConfig = ''
          # Source colors from separate file
          source = ~/.config/hypr/colors.conf
        '';
      };
      
      # Create colors.conf file for Hyprland
      xdg.configFile."hypr/colors.conf".text = ''
        $background = rgb(131318)
        $foreground = rgb(131318)
        $shadow = rgba(00000066)
        $shadow-inactive = rgba(00000066)
        $border_color_active = rgba(bcc2ffFF)
        $border_color_inactive = rgba(13131866)

        $primary=rgb(bcc2ff)
        $primary-fixed= rgb(dfe0ff)
        $primary-fixed-dim= rgb(bcc2ff)
        $on-primary= rgb(242b61)
        $on-primary-fixed= rgb(0d154b)
        $on-primary-fixed-variant= rgb(3b4279)
        $primary-container= rgb(3b4279)
        $on-primary-container= rgb(dfe0ff)
        $secondary= rgb(c4c5dd)
        $secondary-fixed= rgb(e0e1f9)
        $secondary-fixed-dim= rgb(c4c5dd)
        $on-secondary= rgb(2d2f42)
        $on-secondary-fixed= rgb(181a2c)
        $on-secondary-fixed-variant= rgb(434559)
        $secondary-container= rgb(434559)
        $on-secondary-container= rgb(e0e1f9)
        $tertiary= rgb(e6bad7)
        $tertiary-fixed= rgb(ffd7f0)
        $tertiary-fixed-dim= rgb(e6bad7)
        $on-tertiary= rgb(45263d)
        $on-tertiary-fixed= rgb(2d1127)
        $on-tertiary-fixed-variant= rgb(5d3c54)
        $tertiary-container= rgb(5d3c54)
        $on-tertiary-container= rgb(ffd7f0)
        $error= rgb(ffb4ab)
        $on-error= rgb(690005)
        $error-container= rgb(93000a)
        $on-error-container= rgb(ffdad6)
        $surface= rgb(131318)
        $on-surface= rgb(e4e1e9)
        $on-surface-variant= rgb(c7c5d0)
        $outline= rgb(90909a)
        $outline-variant= rgb(46464f)
        $shadow= rgb(000000)
        $scrim= rgb(000000)
        $inverse-surface= rgb(e4e1e9)
        $inverse-on-surface= rgb(303036)
        $inverse-primary= rgb(535a92)
        $surface-dim= rgb(131318)
        $surface-bright= rgb(39393f)
        $surface-container-lowest= rgb(0d0e13)
        $surface-container-low= rgb(1b1b21)
        $surface-container= rgb(1f1f25)
        $surface-container-high= rgb(29292f)
        $surface-container-highest= rgb(34343a)
        $background= rgb(131318)
        $on-background= rgb(e4e1e9)
      '';

      # Create hyprlock configuration file
      xdg.configFile."hypr/hyprlock.conf".text = ''
        # Hyprlock config
        source = $HOME/.config/hypr/colors.conf
        $Scripts = $HOME/.config/hypr/scripts

        general {
            grace = 1
        }

        background {
            monitor =
            path =/tmp/hyprlock_screenshot1.png
            blur_size = 4
            blur_passes = 1
            noise = 0.0117
            contrast = 1.3000
            brightness = 0.8000
            vibrancy = 0.2100
            vibrancy_darkness = 0.0
        }

        input-field {
            monitor =
            size = 250, 50
            outline_thickness = 3
            dots_size = 0.33
            dots_spacing = 0.15
            dots_center = true
            outer_color = $primary
            inner_color = $background
            font_color = $on-background
            fade_on_empty = true
            placeholder_text = <i>Password...</i>
            hide_input = false
            position = 0, 200
            halign = center
            valign = bottom
        }

        # Date
        label {
            monitor =
            text = cmd[update:18000000] echo "<b> "$(date +'%A, %-d %B %Y')" </b>"
            color = $tertiary
            font_size = 34
            font_family = JetBrains Mono Nerd Font Mono ExtraBold
            position = 0, -100
            halign = center
            valign = top
        }

        # Hour-Time
        label {
            monitor =
            text = cmd[update:1000] echo "$(date +"%H")"
            color = $primary 
            font_size = 200
            font_family = JetBrains Mono Nerd Font Mono ExtraBold 
            position = 0, -200
            halign = center
            valign = top
        }

        # Minute-Time
        label {
            monitor =
            text = cmd[update:1000] echo "$(date +"%M")"
            color = $secondary 
            font_size = 200
            font_family = JetBrains Mono Nerd Font Mono ExtraBold
            position = 0, -500
            halign = center
            valign = top
        }

        # Seconds-Time
        label {
            monitor =
            text = cmd[update:1000] echo "$(date +"%S")"
            color = $primary-container
            font_size = 40
            font_family = JetBrains Mono Nerd Font Mono ExtraBold
            position = 0, -500
            halign = center
            valign = top
        }

        # User
        label {
            monitor =
            text = $USER
            color = $on-background
            font_size = 18
            font_family = Inter Display Medium
            position = 0, 100
            halign = center
            valign = bottom
        }
      '';

      # Create hypridle configuration file
      xdg.configFile."hypr/hypridle.conf".text = ''
        general {
            lock_cmd = pidof hyprlock || hyprlock
            before_sleep_cmd = loginctl lock-session
            after_sleep_cmd = hyprctl dispatch dpms on
            ignore_dbus_inhibit = false
        }

        listener {
            timeout = 120
            on-timeout = notify-send "You are idle!"
            on-resume = notify-send "Welcome back!"
        }

        listener {
            timeout = 1800
            on-timeout = loginctl lock-session
        }

        listener {
            timeout = 300
            on-timeout = hyprctl dispatch dpms off
            on-resume = hyprctl dispatch dpms on
        }
      '';
      
      # Configure pyprland
      xdg.configFile."hypr/pyprland.toml".text = ''
        [pyprland]

        plugins = [
          "scratchpads",
          "magnify",
        ]

        [scratchpads.term]
        animation = "fromTop"
        command = "kitty --class kitty-dropterm"
        class = "kitty-dropterm"
        size = "75% 60%"
      '';

      # Create Wallpapers directory if it doesn't exist
      home.file."Pictures/Wallpapers/.keep".text = "";

      # Install required packages for Hyprland configuration
      home.packages = with pkgs; [
        swww                # Wallpaper daemon
        hyprlock            # Screen locker
        hypridle            # Idle daemon
        rofi-wayland        # Application launcher
        wl-clipboard        # Clipboard utilities
        cliphist            # Clipboard history
        pyprland            # Python plugin system for Hyprland
        brightnessctl       # Screen brightness controls
        playerctl           # Media player controls
        grim                # Screenshot utility
        slurp               # Area selection utility
        swappy              # Screenshot annotation
        waybar              # Status bar
        blueman             # Bluetooth manager
        networkmanagerapplet # Network manager applet
        pamixer             # CLI audio volume control
      ];
    };

    # Ensure required system packages are installed
    environment.systemPackages = with pkgs; [
      wl-clipboard         # Wayland clipboard utilities
      cliphist             # Clipboard history
      pyprland             # Python plugin system for Hyprland
      swww                 # Wallpaper daemon
      hyprlock             # Screen locker
      hypridle             # Idle daemon
      grim                 # Screenshot utility
      slurp                # Area selection utility
      swappy               # Screenshot annotation
      waybar               # Status bar
      blueman              # Bluetooth manager
      pamixer              # CLI audio volume control
      networkmanagerapplet # Network manager applet
    ];

    # Enable the related services
    services = {
      # XDG Desktop portal for Wayland
      # xdg-desktop-portal-hyprland.enable = true;
      
      # Desktop services
      upower.enable = true;        # Power management
      blueman.enable = true;       # Bluetooth manager
    };

    # Configure screen locking
    security.pam.services.hyprlock = {};
  };
}
