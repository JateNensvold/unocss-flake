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

        # vite = pkgs.callPackage ./pkgs/vite.nix { };
        unocss = pkgs.callPackage ./pkgs/unocss.nix { };
        unocss-lsp = pkgs.callPackage ./pkgs/unocss-lsp.nix { };
      in {
        devShell = pkgs.mkShell {
          packages = [
            # dev packages
            pkgs.just
            pkgs.pnpm_9

            # test packages
            # unocss
            # unocss-lsp
          ];
        };
        # packages.default = unocss;
        # packages.default = vite;
        packages.unocss = unocss;
        packages.unocss-lsp = unocss-lsp;
      });
}
