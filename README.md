# Toolbox

A plain-text command-line toolbox for storing commands, notes, and output in self-contained, searchable blocks.

Each tool block is written like this:
```bash
#@ ssh.tool
#t keygen ssh agent
#c create and add key to ring
ssh-keygen -t ed25519 -f <hostname>
ssh-agent -s
ssh-add $HOME/.ssh/<private_key>
#n
1) Create the key
2) Start ssh-agent with -s so env vars export
3) Add key to keyring
@#
```
# Usage

Run any tool directly from the terminal:
```bash
$: tb <tool-name>
```
The command reads your bash.toolbox file and prints the selected block.

# Example .bashrc function
```bash
tb() {
    if [[ -z "$1" ]]; then
        echo "Usage: tb <tool>"
        return 1
    fi

    local TOOL="$1"
    local TOOLBOX="${XDG_DATA_HOME:-$HOME/.local/share}/toolbox/bash.toolbox"

    if [[ -f "$TOOLBOX" ]]; then
        awk "/#@ $TOOL.tool/,/@#/" "$TOOLBOX"
    else
        echo "Toolbox not found at: $TOOLBOX"
    fi
}
```

# Notes
- The toolbox file defaults to:
 `$: ${XDG_DATA_HOME:-$HOME/.local/share}/toolbox/bash.toolbox`
- Each tool block starts with `#@ <tool>.tool` and ends with `@#`
- Easily searchable with awk or grep
- Simple, portable, and shell-driven
