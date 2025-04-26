{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    raspberry-pi-nix.url = "github:tstat/raspberry-pi-nix";
    waybar.url = "github:Alexays/Waybar/master";
    nix-gaming.url = "github:fufexan/nix-gaming";
    jovian-nixos.url = "github:Jovian-Experiments/jovian-NixOS";
    nvf.url = "github:notashelf/nvf";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    # claude-desktop = {
    #   url = "github:k3d3/claude-desktop-linux-flake";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-utils.follows = "flake-utils";
    #   };
    # };
    ags = {
      # last commit I had before ags switched to astal (thus breaking my config)
      # TODO: set up quickshell ASAP
      url = "github:Aylur/ags/60180a184cfb32b61a1d871c058b31a3b9b0743d";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  description = "NixOS configuration";

  outputs = { self, nixpkgs, sops-nix, raspberry-pi-nix, pre-commit-hooks, ... }@inputs:
    let
      system = "x86_64-linux"; # Adjust for your system
      pkgs = nixpkgs.legacyPackages.${system};
      pre-commit-check = import ./.pre-commit.nix {
        inherit pre-commit-hooks system;
      };

    in
    {
      nixosConfigurations = {
        # Your existing configurations
        PandorasBox = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            sops-nix.nixosModules.sops
            ./hosts/PandorasBox/default.nix
            ./configuration.nix
            ./home.nix
          ];
        };

        # Hope = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     sops-nix.nixosModules.sops
        #     ./hosts/Hope/default.nix
        #     ./configuration.nix
        #   ];
        # };

        # VM configuration
        # VM = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     sops-nix.nixosModules.sops
        #     ./vm-configuration.nix # Save the VM config to this file
        #   ];
        # };
        # New Raspberry Pi configuration
        RaspberryPi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux"; # Raspberry Pi 4 uses aarch64 architecture
          specialArgs = { inherit inputs; };
          modules = [
            raspberry-pi-nix.nixosModules.raspberry-pi
            raspberry-pi-nix.nixosModules.sd-image
            # ./hosts/RaspberryPi/default.nix  # Create this file for Raspberry Pi specific config
            ./pi_configuration.nix
          ];
        };

        your-hostname = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux"; # Or your architecture
          modules = [
            # ...existing modules...
            ./programs/nvf/default.nix
            # ...other modules...
          ];
        };
      };
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          pre-commit
          nixpkgs-fmt
          statix
          deadnix
        ];
        inherit (pre-commit-check) shellHook;
      };

      # You can also make your repository Nix CI friendly with this:
      checks.${system}.pre-commit-check = pre-commit-check;
      # packages.aarch64-linux.raspberry-pi-image = self.nixosConfigurations.RaspberryPi.config.system.build.sdImage;
      # packages.x86_64-linux.raspberry-pi-image = self.nixosConfigurations.RaspberryPi.config.system.build.sdImage;
    };
}
