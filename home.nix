{ inputs, pkgs, ... }: {

  users.users.eve.isNormalUser = true;
home-manager.users.undead = { pkgs, ... }: {
  home.packages = [ pkgs.atool pkgs.httpie ];
  imports = [ inputs.ags.homeManagerModules.default ];
  programs.zsh.enable = true;
  programs.ags = {
    enable = true;
    # Optional: Specify your AGS configuration directory
    configDir = ./services/ags; # Path relative to home.nix
    # Optional: Add runtime dependencies
    # extraPackages = with pkgs; [ inputs.ags.packages.${pkgs.system}.battery fzf ];
  };
  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.11";
};
}
