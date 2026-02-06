function bournefish --description "Bash compatibility layer for Fish"
    set -l cmd (commandline -j)
    set -l trimmed_cmd (string trim "$cmd")

    if test -z "$trimmed_cmd"
        commandline -f execute
        return
    end

    if string match -qr '^(bash|sudo|time|man|type|which)\s' "$trimmed_cmd"
        commandline -f execute
        return
    end

    set -l bash_detected 0

    if string match -qr '^\s*[A-Za-z_][A-Za-z0-9_]*=' "$trimmed_cmd" # Inline VAR=val
        set bash_detected 1
    else if string match -qr '\[\[ .* \]\]' "$trimmed_cmd" # Double brackets
        set bash_detected 1
    else if string match -qr '^\s*\[ .* \]' "$trimmed_cmd" # Single brackets
        set bash_detected 1
    else if string match -qr '(&>|2>&1)' "$trimmed_cmd" # Bash redirections
        set bash_detected 1
    else if string match -qr '^\s*(export|source|shopt|local|declare|typeset|alias)\s+' "$trimmed_cmd" # Bash builtins
        set bash_detected 1
    end

    if test $bash_detected -eq 1
        set -l escaped_cmd (string escape -- $cmd)
        commandline -r "bash -c $escaped_cmd"
    end

    commandline -f execute
end
