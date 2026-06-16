#!/bin/bash

TMUX_SESSION="CONTROL_TOWER"

control_tower_setup() {
  # session

  if ! tmux has-session -t "${TMUX_SESSION}" 2>/dev/null; then
    tmux new-session -d -s "${TMUX_SESSION}"

    #window_setup
    setup_window_0
    setup_window_1
    setup_window_2
    setup_window_3
  fi

  tmux attach-session -t "$TMUX_SESSION"
}

setup_window_0() {
  WINDOW="Dashboard"

  tmux rename-window -t "${TMUX_SESSION}:0" "${WINDOW}"

  #panel split
  tmux split-window -h -t ${TMUX_SESSION}:${WINDOW}.0
  tmux split-window -v -t ${TMUX_SESSION}:${WINDOW}.0

  # panel setup
  tmux send-keys -t ${TMUX_SESSION}:${WINDOW}.0 "echo project app" C-m
  tmux send-keys -t ${TMUX_SESSION}:${WINDOW}.1 "echo project app" C-m
  tmux send-keys -t ${TMUX_SESSION}:${WINDOW}.2 "make_today" C-m
}

setup_window_1() {
  WINDOW="System"

  tmux new-window -t "${TMUX_SESSION}:1" -n "${WINDOW}"

  # panel setup
  tmux send-keys -t ${TMUX_SESSION}:${WINDOW}.0 "btop" C-m
}

setup_window_2() {
  WINDOW="Network"

  tmux new-window -t "${TMUX_SESSION}:2" -n "${WINDOW}"

  # panel split
  tmux split-window -v -t ${TMUX_SESSION}:${WINDOW}.0
  tmux split-window -h -t ${TMUX_SESSION}:${WINDOW}.0
  # panel setup
  tmux send-keys -t ${TMUX_SESSION}:${WINDOW}.0 "sudo iftop -nP" C-m
  tmux send-keys -t ${TMUX_SESSION}:${WINDOW}.1 "sudo nethogs" C-m
  tmux send-keys -t ${TMUX_SESSION}:${WINDOW}.2 "ss_panel" C-m
}

setup_window_3() {
  WINDOW="Logs"

  tmux new-window -t "${TMUX_SESSION}:3" -n "${WINDOW}"

  # panel split
  tmux split-window -v -t ${TMUX_SESSION}:${WINDOW}.0
  tmux split-window -v -t ${TMUX_SESSION}:${WINDOW}.1
  # panel setup
  tmux send-keys -t ${TMUX_SESSION}:${WINDOW}.0 "failed_services" C-m
  tmux send-keys -t ${TMUX_SESSION}:${WINDOW}.1 "recent_warnings" C-m
  tmux send-keys -t ${TMUX_SESSION}:${WINDOW}.2 "service_log" C-m
}

#====================
# window_0
#====================
make_today() {
  DIARY_DIR="$HOME/dotfiles/secret/diary"
  local today
  today=$(date +%F)

  mkdir -p "$DIARY_DIR"
  nvim "$DIARY_DIR/$today.md"
}

#====================
# window_2
#====================
# ss base service track
ss_panel() {
  watch -t -n 2 '
    echo "=== NETWORK STATUS ====================="
    echo

    echo "Services    : $(ss -tulpnH 2>/dev/null | wc -l)"
    echo "Connections : $(ss -tpnH state established 2>/dev/null | wc -l)"

    echo
    echo "=== OPEN PORTS ========================="
    echo

    ss -tulpnH 2>/dev/null |
    awk '"'"'{
        split($5,a,":")
        port=a[length(a)]

        printf "%-6s %-5s\n",
        port,
        toupper($1)
    }'"'"' |
    sort -n

    echo
    echo "=== ACTIVE CONNECTIONS ================="
    echo

    ss -tpnH state established 2>/dev/null |
    awk '"'"'{
        remote=$5

        split(remote,a,":")

        if(remote ~ /:22$/)
            type="SSH"
        else if(remote ~ /:443$/)
            type="HTTPS"
        else
            type="TCP"

        printf "%-8s %s\n", type, a[1]
    }'"'"' |
    sort -u |
    head -10
    '
}

#=====================
# window_3
#=====================
failed_services() {
  watch -t -n 5 '
    echo "=== FAILED SERVICES ===================="
    echo

    failed=$(systemctl --failed --no-legend 2>/dev/null)

    if [ -z "$failed" ]; then
        echo "No failed services"
    else
        echo "$failed"
    fi
    '
}

recent_warnings() {
  watch -t -n 5 '
    echo "=== RECENT WARNINGS ===================="
    echo

    journalctl -p warning -n 20 \
        --no-pager \
        -o short-iso 2>/dev/null
    '
}

service_log() {
  while true; do
    service=$(
      systemctl list-unit-files \
        --type=service \
        --no-legend |
        awk '{print $1}' |
        sed 's/\.service$//' |
        fzf --prompt="Service > "
    )

    [ -z "$service" ] && break

    journalctl -f -u "$service" -o short-iso

    clear
  done
}
