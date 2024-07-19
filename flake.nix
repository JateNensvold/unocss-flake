{
  description = "A flake for unocss development";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        # pnpm = pkgs.callPackage ./pkgs/pnpm.nix { };
        # unocss = pkgs.callPackage ./pkgs/unocss.nix { pnpm = pnpm; };
        unocss_pkgs = pkgs.callPackage ./pkgs/unocss-cli { };
      in {
        devShell = pkgs.mkShell {
          packages = [
            # dev packages
            pkgs.just
            pkgs.node2nix
            # test packages
            unocss_pkgs."@unocss/cli"
            unocss_pkgs."unocss-language-server"
            unocss_pkgs."@unocss/preset-uno"
          ];
        };
        packages.default = unocss_pkgs;
        packages.unocss-cli = unocss_pkgs."@unocss/cli";
        packages.unocss-lsp = unocss_pkgs."unocss-language-server";
        packages.unocss-uno = unocss_pkgs."@unocss/preset-uno";
      });
}
