source /usr/share/cachyos-fish-config/cachyos-config.fish
# ~/.config/fish/config.fish
starship init fish | source
# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
    # fastfetch
end

# Generated for envman. Do not edit.
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish
