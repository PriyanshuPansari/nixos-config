{ config, lib, pkgs, inputs, ... }:

{
  # Use flakes and nix commands
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Import necessary modules
  imports = [
    inputs.jovian-nixos.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];

  # VM-specific configurations
  virtualisation = {
    # Memory allocation for VM
    memorySize = 4096; # MB
    
    # CPU cores for VM
    cores = 2;
    
    # Graphical display settings
    graphics = true;
    resolution = { x = 1920; y = 1080; };
    
    # Shared directories between host and VM
    sharedDirectories = {
      shared = {
        source = "/path/to/host/directory";
        target = "/mnt/shared";
      };
    };
    
    # Port forwarding
    forwardPorts = [
      { from = "host"; host.port = 2222; guest.port = 22; }  # SSH
    ];
    
    # Use UEFI boot
    useEFI = true;
    
    # Additional QEMU options
    qemu.options = [
      "-device virtio-gpu-pci"  # Better graphics performance
      "-display gtk,grab-on-hover=on"
    ];
  };

  # Hardware settings
  hardware.graphics.enable = true;
  hardware.uinput.enable = true;
  services.fstrim.enable = true;
  boot.kernelModules = [ "uinput" ];

  # Nvidia configuration
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # For VM testing, disable prime sync
  hardware.nvidia.prime.sync.enable = false;

  # Editor configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Jovian Steam configuration
  jovian.steam = {
    enable = true;
    autoStart = true;
    desktopSession = "hyprland";
    user = "undead";  # Your username
  };

  # SOPS secrets configuration - simplified for VM
  sops.defaultSopsFile = ./secrets/vm_secrets.yaml;
  sops.age.generateKey = true;

  # Virtualization within VM (disabled for nested VM)
  virtualisation.docker.enable = false;
  virtualisation.podman.enable = false;

  # Wayland/Hyprland configuration
  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };
  programs.xwayland.enable = true;

  # Group and udev rules
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';
  users.groups.uinput = {};

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking - simplified for VM
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  # Time zone and locale
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "es_CO.UTF-8/UTF-8"
  ];

  # X11 keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Essential packages for VM testing
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    kitty
    waybar
    brightnessctl
    pavucontrol
    rofi-wayland
    wl-clipboard
    zsh
    firefox
    btop
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    noto-fonts
  ];

  # Audio configuration
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Shell configuration
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # User configuration
  users.users.undead = {
    isNormalUser = true;
    description = "VM Test User";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ];
    password = "password"; # Simple password for VM testing
  };

  # System state version
  system.stateVersion = "24.11";
}
