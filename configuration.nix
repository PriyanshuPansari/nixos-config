# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config
, lib
, pkgs
, inputs
, ...
}:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      inputs.nvf.nixosModules.default
      inputs.jovian-nixos.nixosModules.default
      inputs.nix-gaming.nixosModules.platformOptimizations
      inputs.sops-nix.nixosModules.sops
      ./programs/kanata # Import the kanata module
      ./programs/nvf/default.nix # Import nvf configuration
      ./hardware/nvidia.nix # Import NVIDIA-specific configuration
      ./security/ssh.nix # Import SSH and security configuration
    ];
  hardware.i2c.enable = true;
  services.tailscale.enable = true;

  # environment.pathsToLink = [ "/libexec" ];
  programs.nix-ld.enable = true;
  programs.zsh.enable = true;
  nixpkgs.config.cudaSupport = true;
  services.power-profiles-daemon.enable = true;
  home-manager.backupFileExtension = "backup";
  hardware = {
    graphics = {
      enable = true;
    };
    uinput.enable = true;
    bluetooth = {
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      enable = true; # enables support for Bluetooth
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      dynamicBoost.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    nvidia-container-toolkit.enable = true;

  };

  programs = {
    hyprland.enable = true;
    direnv.enable = true;

    zsh = {
      # enable = true;
      interactiveShellInit = ''
        # Load Powerlevel10k
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';
    };


    steam.gamescopeSession.enable = true;
    # systemd.user.enable = true;
    gamemode = {
      enable = true;
    };

    steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    git = {
      enable = true;
    };

    xwayland.enable = true;

  };

  environment.etc."gitconfig".text = ''
    [alias]
      acp = "!f() { git add . && git commit -m \"$*\" && git push; }; f"
      acpm = "!f() { git add . && git commit --amend --no-edit && git push -f; }; f"
      acm = "!f() { git add . && git commit --amend --no-edit; }; f"
  '';

  xdg.mime.defaultApplications = {

    "application/pdf" = "org.qutebrowser.qutebrowser.desktop";
  };

  xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-hyprland ]; };
  users.groups.uinput = { };

  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [
      "input"
      "uinput"
    ];
  };

  virtualisation.podman = {
    enable = true;
  };
  virtualisation.docker.enable = true;
  specialisation = {

    on-the-go.configuration = {
      system.nixos.tags = [ "on-the-go" ];
      hardware.nvidia = {
        prime = {
          offload.enable = lib.mkForce true;
          offload.enableOffloadCmd = lib.mkForce true;
          sync.enable = lib.mkForce false;
        };
        powerManagement.finegrained = lib.mkForce true;
      };
    };
    gaming.configuration = {
      system.nixos.tags = [ "gaming" ];
      services.displayManager.sddm.enable = lib.mkForce false;
      jovian.steam = {
        enable = true;
        desktopSession = "hyprland";
        autoStart = true;
        user = "undead";
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

        __NV_PRIME_RENDER_OFFLOAD = "1";
        NVD_BACKEND = "direct";
        GBM_BACKEND = "nvidia-drm";

        STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "1";
        DXVK_ASYNC = "1";
        PROTON_HIDE_NVIDIA_GPU = "0";

        GAMESCOPE_DISABLE_BUFFERING = "1";
        GAMESCOPE_FORCE_FULLSCREEN = "1";
      };
      programs.steam.platformOptimizations.enable = lib.mkForce true;
    };
  };

  boot = {
    kernelModules = [ "uinput" "ddcci_backlight" ];
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = with config.boot.kernelPackages; [
      config.boot.kernelPackages.ddcci-driver
    ];
    loader.systemd-boot.enable = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelParams = [
      "ddcci.autoprobe_addrs=0x37"
    ];
    extraModprobeConfig = ''
      options nvidia NVreg_TemporaryFilePath=/var/tmp
    '';

    loader.efi.canTouchEfiVariables = true;
  };

  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Kolkata";
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "es_CO.UTF-8/UTF-8"
  ];

  services = {
    fstrim.enable = true;
    blueman.enable = true;

    xserver.videoDrivers = [ "nvidia" ];
    upower.enable = true;
    pulseaudio.enable = false;
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    mangohud
    libgccjit
    nodejs_20
      cups
  cups-filters
  hplip
  system-config-printer
    stdenv.cc.cc
    gcc
    vscode
    code-server
    bc
    cudaPackages.cudatoolkit
    ddcutil
    grim
    slurp
    cheese
    python313
    python313Packages.i3ipc
    unzip
    clipit
    obsidian
    sops
    github-desktop
    ani-cli
    inotify-tools
    nm-tray
    tldr
    google-chrome
    libreoffice
    distrobox
    swww
    eza
    uv
    wget
    git
    kitty
    mpv
    waybar
    yazi
    lutris
    matugen
    jq
    brightnessctl
    pavucontrol
    lm_sensors
    rofi-wayland
    qutebrowser
    zoxide
    swaynotificationcenter
    cliphist
    hyprlock
    pamixer
    zsh-powerlevel10k
    ripgrep
    playerctl
    btop
    pyprland
    firefox
    sshfs
    wl-clipboard
    zsh
  ];
  services.printing = {
  enable = true;
  drivers = [ pkgs.hplip ];
};

services.avahi = {
  enable = true;
  nssmdns = true;
  openFirewall = true;
};
  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    noto-fonts
  ];

  networking.firewall.enable = false;

  security.rtkit.enable = true;
  users.defaultUserShell = pkgs.zsh;

  system.stateVersion = "24.11"; # Did you read the comment?

}
