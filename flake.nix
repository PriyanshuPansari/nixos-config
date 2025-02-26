{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    jovian-nixos.url = "github:Jovian-Experiments/Jovian-NixOS";
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
    };
  };
}
