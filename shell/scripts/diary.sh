#!/bin/bash

DIARY_DIR="$HOME/dotfiles/secret/diary"

make_today() {
  local today
  today=$(date +%F)

  mkdir -p "$DIARY_DIR"
  nvim "$DIARY_DIR/$today.md"
}
