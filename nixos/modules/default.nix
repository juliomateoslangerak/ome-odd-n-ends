{
  imports = [
    ./omero
    ./postgres.nix
    ./swap-file.nix  # NOTE lifted from trixie-dotses
    ./users.nix      # NOTE lifted from trixie-dotses
  ];
}
