{ config, pkgs, ... }:

{
  # Define the user "undead"
  # users.users.undead = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" "input" "uinput" ]; # wheel for sudo, input/uinput for kanata
  #   home = "/home/undead";
  # };
# Boot settings for Raspberry Pi
  boot.loader.grub.enable = false;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 4;
  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  # Disable NVIDIA settings
  hardware.nvidia.enable = false;
services.openssh.enable = true;
  # Use vc4 driver for Raspberry Pi GPU
  services.xserver.videoDrivers = [ "vc4" ];

  # Hardware graphics support
  hardware.graphics = {
    enable = true;
  };

  # Uinput for kanata
  boot.kernelModules = [ "uinput" ];
  hardware.uinput.enable = true;
  users.groups.uinput = { };
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  # Kanata service (adjust device paths as needed)
  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          # Replace with actual Raspberry Pi keyboard device paths after setup
          "/dev/input/by-path/platform-ff300000.usb-usb-0:1.1:1.0-event-kbd"
        ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
            a   s   d   f   j   k   l   ;
          )
          (defvar
            tap-time 200
            hold-time 150
            left-hand-keys (
              q w e r t
              a s d f g
              z x c v b
            )
            right-hand-keys (
              y u i o p
              h j k l ;
              n m , . /
            )
          )
          (deflayer base
            @a  @s  @d  @f  @j  @k  @l  @;
          )
          (deflayer nomods
            a   s   d   f   j   k   l   ;
          )
          (deflayer arrows
            _   _   _   _   left down up   right
          )
          (deffakekeys
            to-base (layer-switch base)
          )
          (defalias
            tap (multi
              (layer-switch nomods)
              (on-idle-fakekey to-base tap 20)
            )
            a (tap-hold-release-keys $tap-time $hold-time (multi a @tap) lmet $left-hand-keys)
            s (tap-hold-release-keys $tap-time $hold-time (multi s @tap) lalt $left-hand-keys)
            d (tap-hold-release-keys $tap-time $hold-time (multi d @tap) lctl $left-hand-keys)
            f (tap-hold-release-keys $tap-time $hold-time (multi f @tap) lsft $left-hand-keys)
            j (tap-hold-release-keys $tap-time $hold-time (multi j @tap) rsft $right-hand-keys)
            k (tap-hold-release-keys $tap-time $hold-time (multi k @tap) rctl $right-hand-keys)
            l (tap-hold-release-keys $tap-time $hold-time (multi l @tap) ralt $right-hand-keys)
            @j (layer-switch arrows)
            @k (layer-switch arrows)
            @l (layer-switch arrows)
            @; (layer-switch arrows)
          )
        '';
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
  vim 
  git 
  kitty
  rofi-wayland
  
  ];
  fonts.packages = with pkgs; [
	nerd-fonts.droid-sans-mono
	noto-fonts
];
 programs.hyprland.enable = true;
  # Optional: Enable Raspberry Pi-specific hardware tweaks
  hardware.raspberry-pi."4".fkms-3d.enable = true; # Enable 3D acceleration
}
