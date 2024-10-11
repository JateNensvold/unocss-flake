# unocss-flake

A small collection of nix derivations for installing unocss and its utilities

## Dependencies

With nix and direnv installed the development environment will be setup automatically

- nix
- direnv

## Development

1. Add a new package to [./pkgs/](./pkgs/)
2. Add the package as a build target in [./flake.nix](./flake.nix)
3. Run the following command `just build <package-name>` which will generate a nix derivation for a package.
