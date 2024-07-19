# just manual: <https://github.com/casey/just/#readme>

_default:
    @just --list

build:
	node2nix -i ./pkgs/unocss-cli/node-packages.json -o ./pkgs/unocss-cli/node-packages.nix --composition ./pkgs/unocss-cli/default.nix --node-env ./pkgs/unocss-cli/node-env.nix
