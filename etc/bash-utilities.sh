# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
function findcc {
find . \( -name '*.cc' -o -name '*.cpp' -o -name '*.c' \) -exec grep "$1" {} \; -print
}

function findh {
find . \( -name '*.h' -o -name '*.hpp' \) -exec grep "$1" {} \; -print
}

function findrst {
find . -name '*.rst' -exec grep "$1" {} \; -print
}

export VISUAL=vi

