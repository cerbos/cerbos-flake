# Cerbos flake

A Nix flake to launch [Cerbos](https://github.com/cerbos/cerbos).

```shell
# Launch a Cerbos server
nix run github:cerbos/cerbos-flake#cerbos -- server --set=storage.disk.directory=/path/to/policy_directory

# Launch a REPL
nix run github:cerbos/cerbos-flake#cerbos -- repl

# Launch cerbosctl
nix run github:cerbos/cerbos-flake#cerbosctl
```
