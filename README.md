# Overlay Shim

A nix flake that acts as a stand-in for overlays to nixpkgs. Possible usage:

```nix
{
  description = "My library flake";

  inputs.nixpkgs.url = "flake:nixpkgs";
  inputs.overlays.url = "github:thelonelyghost/blank-overlay-nix";
  inputs.flake-utils.url = "flake:flake-utils";

  outputs = { self, nixpkgs, overlays, flake-utils }:
    (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [overlays.overlays.default];
      };
    in
    {
      # ...
    }
  ));
}
```

This would allow something downstream to consume the flake like so:

```nix
{
  description = "My library flake";

  inputs.nixpkgs.url = "flake:nixpkgs";
  inputs.overlays.url = "flake:company-overlays";
  inputs.flake-utils.url = "flake:flake-utils";
  inputs.my-lib-nix.url = "flake:my-lib";
  inputs.my-lib-nix.inputs.overlays.follows = "overlays";

  outputs = { self, nixpkgs, overlays, flake-utils, my-lib-nix }:
    (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [overlays.overlays.default];
      };
      my-lib = my-lib-nix.outputs.packages."${system}";
    in
    {
      # ...
    }
  ));
}
```

This would include the environment-specific overlays to be inherited to each underlying system. In cases like where a MITM traffic inspection proxy is put in place, especially in enterprise environments, many features of nix break and do not honor the `NIX_SSL_CERT_FILE` environment variable as they are supposed to. This pattern abstracts that concern.

