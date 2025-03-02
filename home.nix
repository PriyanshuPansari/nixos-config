{ inputs, pkgs, ... }: {
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    # Optional: Specify your AGS configuration directory
    # configDir = ../ags-config; # Path relative to home.nix
    # Optional: Add runtime dependencies
    # extraPackages = with pkgs; [ inputs.ags.packages.${pkgs.system}.battery fzf ];
  };
}
