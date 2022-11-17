{
  description = "A flake that acts as a shim to be overridden, providing an overlay that does nothing";

  outputs = { self }: {
    overlays.default = final: prev: {};
  };
}
