{
  description = "A flake for unocss development";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        shellPkgs = import nixpkgs { inherit system; };
        unocss = shellPkgs.callPackage ./unocss.nix { };
      in {
        devShell = shellPkgs.mkShell {
          packages = [ unocss ];

        };
      });

}
