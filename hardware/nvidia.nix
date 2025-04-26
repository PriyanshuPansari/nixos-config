# NVIDIA hardware configuration
{ config, lib, pkgs, ... }:

{
  hardware.nvidia = {
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

  hardware.nvidia-container-toolkit.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Specialisation for power-saving/on-the-go mode
  specialisation.on-the-go.configuration = {
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

  # Specialisation for gaming mode
  specialisation.gaming.configuration = {
    system.nixos.tags = [ "gaming" ];
    services.xserver.displayManager.sddm.enable = lib.mkForce false;
    jovian.steam = {
      enable = true;
      desktopSession = "hyprland";
      autoStart = true;
      user = "undead";
    };

    # NVIDIA-specific environment variables for gaming
    environment.sessionVariables = {
      # Core NVIDIA variables
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

      # Direct rendering
      __NV_PRIME_RENDER_OFFLOAD = "1";
      NVD_BACKEND = "direct";
      GBM_BACKEND = "nvidia-drm";

      # Steam/Gamescope specific
      STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "1";
      DXVK_ASYNC = "1"; # Better performance for DXVK games
      PROTON_HIDE_NVIDIA_GPU = "0";

      # Disable compositing and VRR for maximum performance
      GAMESCOPE_DISABLE_BUFFERING = "1";
      GAMESCOPE_FORCE_FULLSCREEN = "1";
    };
    programs.steam.platformOptimizations.enable = lib.mkForce true;
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod;
  };
}
