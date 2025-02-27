{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    jovian-nixos.url = "github:Jovian-Experiments/Jovian-NixOS";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, sops-nix, jovian-nixos, ... }@inputs: {
    nixosConfigurations = {
      # Your existing configurations
      PandorasBox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          sops-nix.nixosModules.sops
          ./hosts/PandorasBox/default.nix
          ./configuration.nix
        ];
      };
      
      Hope = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          sops-nix.nixosModules.sops
          ./hosts/Hope/default.nix
          ./configuration.nix
        ];
      };
      
      # VM configuration
      VM = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          sops-nix.nixosModules.sops
          jovian-nixos.nixosModules.default
          ./vm-configuration.nix  # Save the VM config to this file
        ];
      };
       # New Raspberry Pi configuration
      RaspberryPi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";  # Raspberry Pi 4 uses aarch64 architecture
        specialArgs = { inherit inputs; };
        modules = [
          sops-nix.nixosModules.sops
          nixos-hardware.nixosModules.raspberry-pi-4
          ./hosts/RaspberryPi/default.nix  # Create this file for Raspberry Pi specific config
          ./pi_configuration.nix
        ];
      };
    };
    packages.aarch64-linux.sdImage = let
      config = self.nixosConfigurations.RaspberryPi.config;
    in
      nixpkgs.legacyPackages.aarch64-linux.callPackage "${nixpkgs}/nixos/lib/make-disk-image.nix" {
        inherit config;
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        lib = nixpkgs.lib;
        format = "raw";
        partitionTable = "msdos";
      };
  };
}
