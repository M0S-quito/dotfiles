source $HOME/dotfiles/install/.packages

install_apt() {
  sudo apt update
  sudo apt install -y "${PACKAGES[@]}"
}
