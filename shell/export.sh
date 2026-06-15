# less behavior (pager enhancement)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# dircolors (ls 색상 기반 설정)
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" ||
    eval "$(dircolors -b)"
fi

# optional GCC colors (주석 유지 가능)
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01:quote=01'

# PATH settig
export PATH="$HOME/apps/nvim-linux-x86_64/bin:${PATH}"

# env setting
# set -a
# source .env
# set +a

# ==================
# scripts
# ==================
SCRIPTS_DIR="$HOME/dotfiles/shell/scripts"

for file in "$SCRIPTS_DIR"/*.sh; do
  [ -r "$file" ] && source "$file"
done

diary() {
  make_today "$@"
}
