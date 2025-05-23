
{
  nix = {
    settings = {
      substituters = [
        "https://nix-shell.cachix.org"
      ];
      trusted-public-keys = [
        "nix-shell.cachix.org-1:kat3KoRVbilxA6TkXEtTN9IfD4JhsQp1TPUHg652Mwc="
      ];
    };
  };
}
