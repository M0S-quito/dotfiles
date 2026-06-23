#!/usr/bin/env bash
set -e

DOTFILES="${HOME}/dotfiles"

echo ">>> Installing dotfiles..."

# dotfiles 존재 파악
if [ ! -d "${DOTFILES}" ]; then
  echo "dotfiles not found"
  exit 1
fi

# 섪치파일 받아 오기
source "${DOTFILES}/install/.packages"

if command -v apt >/dev/null 2>&1; then
  source "${DOTFILES}/install/apt.sh"
  install_apt
fi

# 기존 dotfiles 백업 폴더
BACKUP="$HOME/.dotfiles_backup"
mkdir -p "${BACKUP}"

backup() {
  if [ -e "$1" ] && [ ! -L "$1" ]; then
    echo "backup: $1"
    mv "$1" "${BACKUP}/"
  fi
}

# ================
# dotfiles backup
# ================
backup "${HOME}/.bashrc"
ln -sfn "${DOTFILES}/shell/bashrc" "${HOME}/.bashrc"

backup "${HOME}/.profile"
ln -sfn "${DOTFILES}/shell/profile" "${HOME}/.profile"

backup "${HOME}/.config/nvim"
ln -sfn "${DOTFILES}/config/nvim" "${HOME}/.config/nvim"

backup "${HOME}/.tmux.conf"
ln -sfn "${DOTFILES}/config/tmux/.tmux.conf" "${HOME}/.tmux.conf"

backup "${HOME}/.gitconfig"
ln -sfn "${DOTFILES}/config/git/.gitconfig" "${HOME}/.gitconfig"

echo ">>> done!"
