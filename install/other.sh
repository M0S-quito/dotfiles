install_nvim() {
  set -e

  nvim_ver="0.12.3"

  BASE_DIR="$HOME/install_files/nvim"
  TAR_FILE="$BASE_DIR/nvim.tar.gz"

  echo ">> preparing dirs"
  rm -rf "$BASE_DIR"
  mkdir -p "$BASE_DIR"

  echo ">> downloading"
  curl -L "https://github.com/neovim/neovim/releases/download/v${nvim_ver}/nvim-linux-x86_64.tar.gz" \
    -o "$TAR_FILE"

  echo ">> extracting"
  tar -xzf "$TAR_FILE" -C "$BASE_DIR"

  rm -f "$TAR_FILE"

  echo ">> linking"
  ln -sf "${BASE_DIR}/nvim-linux-x86_64/bin/nvim" "${HOME}/usr/bin/nvim"

  echo ">> done"
  nvim --version
}
