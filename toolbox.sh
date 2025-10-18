


# file: toolbox.sh
# author: jackam@github


# tool retrieval from toolbox (tb)
# usage: tb <tool-name>
tb() {
	if [[ -z "${1}" ]]; then
		echo "Usage: tb <tool>"
		return 1
	fi
	_ui_spinner
	_ui_header
	local TOOL="${1}"
	local TOOLBOX="${XDG_DATA_HOME:-$HOME/.local/share}/toolbox/cli.toolbox"
	if [[ ! -f ${TOOLBOX} ]]; then
		echo "Toolbox not found at: ${TOOLBOX}"
		return 1
	fi
	awk "/^#@ $TOOL.tool/,/^@#/" "${TOOLBOX}"
	_ui_footer
}

# search toolbox by tag
# usage: tb.search <tag>
tb.search() {
	if [[ -z "${1}" ]]; then
		echo "tb.search <tag>"
		return 1
	fi
	local TAG="${1}"
	local TOOLBOX="${XDG_DATA_HOME:-$HOME/.local/share}/toolbox/cli.toolbox"
	if [[ ! -f "${TOOLBOX}" ]]; then
		echo "Toolbox not found at: ${TOOLBOX}"
		return 1
	fi
	_ui_spinner
	_ui_header
	awk -v tag="${TAG}" '
		/^#@/ {inblock=0; block=""}
		{block=block $0 "\n"}
		/^#t/ && index(tolower($0), tolower(tag)) {inblock=1}
		/^@#/ && inblock {print block}
		' "${TOOLBOX}"
	_ui_footer
}

_ui_header() {
	local term_width
	term_width=$(tput cols)
	local left="[+] ^^^" 
	local middle="Toolbox"
	local right="^^^ [+]"
	local total_space=$(( term_width - ${#left} - ${#middle} - ${#right} ))
	local pad_left=$(( total_space / 2 ))
	local pad_right=$(( total_space - pad_left ))
	if (( total_space < 0 )); then total_space=0; fi
	printf "%s%*s%s%*s%s\n\n" "${left}" "${pad_left}" "" "${middle}" "${pad_right}" "" "${right}"
}

_ui_footer() {
	local term_width
	term_width=$(tput cols)              # get terminal width
	local left="[+] ^^^"
	local right="^^^ [+]"
	local total_space=$(( term_width - ${#left} - ${#right} ))
	if (( total_space < 0 )); then total_space=0; fi
	printf "\n"
	printf "%s%*s%s\n" "${left}" "${total_space}" "" "${right}"
	printf "\n"
}

# cli spinner effect for toolbox queries
_ui_spinner() {
	local spinarr=('/' '-' '\' '|')  # array of characters
	local delay=0.1
	local i c
	for i in $(seq 1 20); do
		c="${spinarr[$((i % 4))]}"   # cycle through array
		printf "\r[%s] Searching toolbox" "$c"
		sleep "$delay"
	done
	printf "\r                     \n"
}

