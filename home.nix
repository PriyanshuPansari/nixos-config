{ inputs, ... }: {
  users.users.undead.isNormalUser = true;
  # home-manager.backupFileExtension = "backup";
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
  };
  home-manager.users.undead = { pkgs, ... }: {
    imports = [ inputs.ags.homeManagerModules.default ];
    # programs.zsh.enable = true;
    programs.autorandr.enable = true;
    # The state version is required and should stay at the version you
    # originally installed.
    # programs.neovim = {
    # enable = true;
    # defaultEditor = true;
    # viAlias = true;
    # vimAlias = true;
    # vimdiffAlias = true;
    # };
    home.stateVersion = "24.11";
  };

}
