{ inputs, ... }: {
  users.users.undead.isNormalUser = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.undead = { pkgs, ... }: {
    imports = [ inputs.ags.homeManagerModules.default ];
    # programs.zsh.enable = true;
    programs.ags = {
      enable = true;
      # Optional: Specify your AGS configuration directory
      configDir = ./services/ags; # Path relative to home.nix
      # Optional: Add runtime dependencies
      # extraPackages = with pkgs; [ inputs.ags.packages.${pkgs.system}.battery fzf ];
      extraPackages = with pkgs;  [
        atool
        httpie
        gnome-control-center
        resources
        hyprland
        overskride
        wlogout
        bash
        coreutils
        dart-sass
        gawk
        power-profiles-daemon
        inotify-tools
        imagemagick
        inotify-tools
        procps
        ripgrep
        util-linux
      ];
    };
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.11";
  };
}
