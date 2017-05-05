{ pkgs, pykgs, ... }:

with pkgs;
{
  deps = callPackage ./deps.nix { inherit pykgs; };
  server = callPackage ./server.nix {};
}
