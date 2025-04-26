{ pre-commit-hooks, system }:
pre-commit-hooks.lib.${system}.run {
  src = ./.;
  hooks = {
    # Built-in hooks
    nixpkgs-fmt.enable = true;
    statix = {
      enable = true;
      excludes = [ "^./hosts/.*/hardware-configuration\.nix$" "^./.direnv/.*" ];
    };
    deadnix = {
      enable = true;
      # Uncomment if you want it to automatically modify files
      # extraArgs = ["--edit"];
    };
  };
  # Custom hooks need to be defined differently
  # hooks.nixos-rebuild-check = {
  #   enable = true;
  #   name = "Test NixOS configuration";
  #   description = "Checks that the NixOS configuration builds correctly";
  #   entry = "nixos-rebuild dry-build --flake .#";
  #   language = "system";
  #   pass_filenames = false;
  #   files = "\\.nix$";
  # };
  # # Add tools required by hooks
  # tools = {
  #   nixos-rebuild = pkgs.nixos-rebuild;
  # };
}
