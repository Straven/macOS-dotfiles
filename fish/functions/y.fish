# Yazi shell wrapper
# Start with y, q - exit with changing cwd, Q - exits without changing cwd

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
