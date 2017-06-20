#
# Nix expression to set up an environment to build Smuggler's doc generation
# app. We use Cabal instead of Stack, but the workflow is exactly the same
# as documented at:
# - https://github.com/c0c0n3/ome-smuggler/tree/gh-pages
# except you run Cabal commands instead of Stack's, specifically use
#     -------------------------  instead of  -------------------------
#     $ cabal configure                      $ stack setup
#     $ cabal build                          $ stack build
#     $ cabal run docs-gen <cmd>             $ stack exec docs-gen <cmd>
#
{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc802" }:  # NOTE (2) (4)

with import ./util.nix;

let
  inherit (nixpkgs) pkgs;

  cabal = pkgs.cabal-install;

  ghc-with-deps = pkgs.haskell.packages."${compiler}".ghcWithPackages
    (ps: with ps; [  # NOTE (3)
      containers
      filepath
      hakyll
      here
      pandoc
      pandoc-types
      text
      xml-conduit
    ]);

  shell-name = "smugs-docs";
in
pkgs.stdenv.mkDerivation
{
  name = shell-name;

  buildInputs = [ cabal ghc-with-deps ];

  shellHook = ''
    eval $(egrep ^export ${ghc-with-deps}/bin/ghc)
    ${setPrompt { inherit shell-name; }}
  '';  # NOTE (5)
}
# Notes
# -----
# 1. Why Cabal? Smuggler's doc app build is Stack-based, so it may be easier
# to set up a Stack-based environment instead. Or so I thought. In fact, I'm
# not sure I understand fully how a Stack-based build is supposed to work on
# NixOS. I tried a simple Nix expression with `buildInputs` containing `stack`
# and `gnumake` (`stack setup` fails without it) but then `stack build` failed
# to build my project because some Haskell package (can't remember which) has
# a dep on a native lib, `zlib`. Adding `zlib` to the `buildInputs` didn't
# work either as the package Stack pulls from Hackage can't possibly know where
# to find `zlib`. In fact, it stands to reason that if a Hackage package has a
# native dependency, you should probably use a Nixified version of it?
#
# 2. Haskell package versions. Should be exactly the same as the ones in the
# LTS set declared in `stack.yaml`, currently LTS 4.2 built with GHC 7.10.3.
# The Nix package set `ghc7103` is roughly equivalent but it doesn't build!
# Just try setting `compiler` to `ghc7103` and then instantiating with
# `nix-shell`; you should get a build error similar to this:
#
#     Configuring tasty-ant-xml-1.0.4...
#     Setup: At least the following dependencies are missing:
#     directory >=1.2.6.2, filepath >=1.4.1.0
#     builder for ‘/nix/store/...-tasty-ant-xml-1.0.4.drv’ failed ...
#
# 3. Haskell deps. Should be exactly the same as what's in `docs-app.cabal`.
# Consider using `cabal2nix`.
#
# 4. Pinning Nixpkgs. Can be done if needed. For a simple way to do that look
# at my notes in `omero*.nix`. For an equivalent but more robust and flexible
# approach, look at:
# - https://github.com/Gabriel439/haskell-nix/tree/master/project0#pinning-nixpkgs
#
# 5. Env vars. We need to set the same variables exported by the GHC wrapper
# script. See:
# - http://nixos.org/nixpkgs/manual/#how-to-create-ad-hoc-environments-for-nix-shell
#
