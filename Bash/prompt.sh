# detect chroot for prompt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# detect terminal color support
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# optional force color
#if [ -n "$force_color_prompt" ]; then
#  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#    color_prompt=yes
#  else
#    color_prompt=
#  fi
#fi

# prompt itself
#if [ "$color_prompt" = yes ]; then
#  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi

#unset color_prompt force_color_prompt

# xterm title
#case "$TERM" in
#xterm* | rxvt*)
#  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#  ;;
#esac

git_branch() {
  git branch --show-current 2>/dev/null
}

tmux_info() {
  [ -n "$TMUX" ] && tmux display-message -p "#S:#I:#W" || echo "-"
}

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\
\[\033[01;32m\]\u\[\033[00m\] \
\[\033[01;36m\][tmux:$(tmux_info)]\[\033[00m\] \
\[\033[01;35m\][git:$(git_branch)]\[\033[00m\]\
\n\[\033[01;34m\]\w\[\033[00m\] ❯ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u [tmux:$(tmux_info)] [git:$(git_branch)]\n\w ❯ '
fi

unset color_prompt force_color_prompt

# xterm title
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u: \w\a\]$PS1"
  ;;
esac
