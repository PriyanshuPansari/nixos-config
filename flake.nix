{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    xremap.url = "github:xremap/nix-flake/master";
};
  outputs = { self, nixpkgs, xremap }@inputs: {
    # replace 'joes-desktop' with your hostname here.
    nixosConfigurations ={

    PandorasBox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
      ./hosts/PandorasBox/default.nix
      ./configuration.nix ];
    };
  };

    Hope = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
      ./hosts/Hope/default.nix
      ./configuration.nix ];
    };
  };
}
