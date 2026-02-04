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

    if string match -qr '^\s*[A-Za-z_][A-Za-z0-9_]*=' "$trimmed_cmd"
        set bash_detected 1
    else if string match -qr '`.*`' "$trimmed_cmd"
        set bash_detected 1
    else if string match -qr '\$\(.*\)' "$trimmed_cmd"
        set bash_detected 1
    else if string match -qr '\[\[ .* \]\]' "$trimmed_cmd"
        set bash_detected 1
    else if string match -qr '&>' "$trimmed_cmd"
        set bash_detected 1
    else if string match -qr '^\s*\[\s+' "$trimmed_cmd"
        set bash_detected 1
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
