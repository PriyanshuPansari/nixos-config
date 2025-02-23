{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
};
  outputs = { self, nixpkgs, sops-nix }@inputs: {
    # replace 'joes-desktop' with your hostname here.
    nixosConfigurations ={

    PandorasBox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
       sops-nix.nixosModules.sops
      ./hosts/PandorasBox/default.nix
      ./configuration.nix ];
    };

    Hope = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
       sops-nix.nixosModules.sops
      ./hosts/Hope/default.nix
      ./configuration.nix ];
    };
  };
  };
}
