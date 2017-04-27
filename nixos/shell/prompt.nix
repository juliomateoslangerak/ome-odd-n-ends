#
# Sets the Bash prompt for our Nix shells.
# Use in a shellHook, e.g.
#
#     with import ./prompt.nix;
#     ...
#     shellHook = ''
#       ${setPrompt { shell-name = "my prompt"; }}
#     '';
#
{
  setPrompt = { shell-name ? "nix-shell", prompt-colour ? 1 }:
  let
    set-colour = "$(tput setaf ${toString prompt-colour})";
    reset-colour = "$(tput sgr0)";
  in
  ''
    export PS1='${set-colour}*${shell-name}*${reset-colour} '
  '';
}
