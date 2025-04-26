# Git configuration
{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
  };

  # Global Git configuration
  environment.etc."gitconfig".text = ''
    [alias]
      acp = "!f() { git add . && git commit -m \"$*\" && git push; }; f"
      acpm = "!f() { git add . && git commit --amend --no-edit && git push -f; }; f"
      acm = "!f() { git add . && git commit --amend --no-edit; }; f"
  '';
}
