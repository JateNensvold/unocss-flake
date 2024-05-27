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
            # comment
            unocss_pkgs."@unocss/cli"
            pkgs.node2nix
          ];
        };
        packages.default = unocss_pkgs;
        packages.unocss-cli = unocss_pkgs."@unocss/cli";
      });
}
