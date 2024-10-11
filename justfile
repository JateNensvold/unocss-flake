# just manual: <https://github.com/casey/just/#readme>

_default:
    @just --list

build-s:
	just build-pkg-s unocss

build-pkg-s PACKAGE:
	node2nix -i ./pkgs/{{PACKAGE}}/node-packages.json \
	-o ./pkgs/{{PACKAGE}}/node-packages.nix \
	--composition ./pkgs/{{PACKAGE}}/default.nix \
	--node-env ./pkgs/{{PACKAGE}}/node-env.nix \
	--supplement-input ./pkgs/{{PACKAGE}}/supplement.json \
	--supplement-output ./pkgs/{{PACKAGE}}/supplement.nix -18


build PACKAGE:
	nix build .#{{PACKAGE}}

build-pkg PACKAGE:
	node2nix -i ./pkgs/{{PACKAGE}}/node-packages.json \
	-o ./pkgs/{{PACKAGE}}/node-packages.nix \
	--composition ./pkgs/{{PACKAGE}}/default.nix \
	--node-env ./pkgs/{{PACKAGE}}/node-env.nix -18
