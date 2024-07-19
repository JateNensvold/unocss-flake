# unocss-flake

A small collection of nix derivations for installing unocss and its utilities

## Dependencies

With nix and direnv installed the development environment will be setup automatically

- nix
- direnv

## Development

1. Add a new package to [./pkgs/unocss-cli/node-packages.json](./pkgs/unocss-cli/node-packages.json)
2. Run the following command `just build` which will generate a nix derivation
for the package.
