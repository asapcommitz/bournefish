function bournefish --description "Bash compatibility layer for Fish"
    set -l cmd (commandline)
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

    # 1. Inline variable assignment: VAR=val ...
    if string match -qr '^\s*[A-Za-z_][A-Za-z0-9_]*=' "$trimmed_cmd"
        set bash_detected 1
    # 2. Backticks (anywhere)
    else if string match -qr '`' "$trimmed_cmd"
        set bash_detected 1
    # 3. Bash subshells $(...) or double dynamic variables ${...}
    else if string match -qr '\$\(.*\)' "$trimmed_cmd"
        set bash_detected 1
    # 4. Double brackets [[ ... ]]
    else if string match -qr '\[\[ .* \]\]' "$trimmed_cmd"
        set bash_detected 1
    # 5. Bash redirections
    else if string match -qr '(&>|2>&1|1>&2)' "$trimmed_cmd"
        set bash_detected 1
    # 6. Test brackets [ ... ] at the start
    else if string match -qr '^\s*\[\s+' "$trimmed_cmd"
        set bash_detected 1
    # 7. Bash builtins
    else if string match -qr '^\s*(export|source|shopt|local|declare|typeset)\s+' "$trimmed_cmd"
        set bash_detected 1
    end

    if test $bash_detected -eq 1
        commandline -f repaint
        history add "$cmd"
        echo ""
        bash -c "$cmd"
        set -l exit_code $status
        commandline -r ""
        commandline -f execute
        return $exit_code
    end

    commandline -f execute
end
