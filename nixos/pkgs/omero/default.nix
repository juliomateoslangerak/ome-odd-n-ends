{ pkgs, zeroc-ice-py, ... }:

with pkgs;

{

  deps = callPackage ./deps.nix { inherit zeroc-ice-py; };
  server = callPackage ./server.nix {};

}
