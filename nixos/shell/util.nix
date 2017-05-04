#
# Utility functions for our Nix shells.
#
rec {

  # Sets the Bash prompt for our Nix shells.
  # Use in a shellHook, e.g.
  #
  #     shellHook = ''
  #       ${setPrompt { shell-name = "my prompt"; }}
  #     '';
  #
  setPrompt = { shell-name ? "nix-shell", prompt-colour ? 1 }:
  let
    set-colour = "$(tput setaf ${toString prompt-colour})";
    reset-colour = "$(tput sgr0)";
  in
  ''
    export PS1='${set-colour}*${shell-name}*${reset-colour} '
  '';

  # Sets Bash prompt and SLICEPATH for our OMERO shells.
  # Use in a shellHook, e.g.
  #
  #     shellHook = setShellHook {
  #       shell-name = "omero";
  #       zeroc_ice = pkgs.zeroc_ice;
  #     };
  #
  setShellHook = { shell-name, zeroc_ice }:
  ''
    ${setPrompt { inherit shell-name; }}
    export SLICEPATH="${zeroc_ice}/slice"
  '';

}
