{
  description = "Nixos config";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-26.05;
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager= {
    url = github:nix-community/home-manager/release-26.05; 
    inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = github:Mic92/sops-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fiction-tracker = {
      url = "git+file:///home/undead/fiction-tracker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    paper-server = {
      url = "git+file:///home/undead/paper-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    site-shelf = {
      url = "git+file:///home/undead/site-shelf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@attrs: {
	nixosConfigurations.hope = nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";
		specialArgs = attrs;
		modules = [
			./configuration.nix
			./servers
			attrs.sops-nix.nixosModules.sops
			attrs.fiction-tracker.nixosModules.default
			attrs.paper-server.nixosModules.default
			attrs.site-shelf.nixosModules.default
		];
	};
  };
}
