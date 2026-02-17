#!/bin/bash
# set +x

SCRIPT_DIR=$(cd $(dirname $0); pwd)
SETUP_FILES=`ls -1a | grep -E '^\.' | grep -v -E '^(\.|\.\.|\.git|\.gitignore|\.config|bin)$'`
CONFIGS=`ls -1a ${SCRIPT_DIR}/configs/. | grep -v -E '^(\.|\.\.|\.git)$'`
BINS=`ls -1a ${SCRIPT_DIR}/bin/. | grep -v -E '^(\.|\.\.|\.git)$'`

if [[ "$SHELL" != */fish ]]; then
    echo "Warning: Default shell is not fish (current: $SHELL)"
    echo "To make changes, execute the following command"
    echo "cat /etc/shells"
    echo "echo (which fish) | sudo tee -a /etc/shells"
    echo "chsh -s (which fish)"
fi

function create_symbolic_link() {
  if [ ! -e "$2" ]; then
    echo "create Symbolic link" "$2"
    ln -s "$1" "$2"
  else
    echo "skip Symbolic link" "$2"
  fi
}

function create_symbolic_links() {
  for file in ${SETUP_FILES[@]}
  do
    create_symbolic_link "${SCRIPT_DIR}/${file}" "${HOME}/${file}"
  done
}

function create_config_symbolic_links() {
  if [ ! -d "${HOME}/.config" ]; then
    mkdir "${HOME}/.config"
  fi

  for file in ${CONFIGS[@]}
  do
    create_symbolic_link "${SCRIPT_DIR}/configs/${file}" "${HOME}/.config/${file}"
  done
}

function create_bin_symbolic_links() {
  if [ ! -d "${HOME}/bin" ]; then
    mkdir "${HOME}/bin"
  fi
  for file in ${BINS[@]}
  do
    create_symbolic_link "${SCRIPT_DIR}/bin/${file}" "${HOME}/bin/${file}"
  done
}

function install_rust() {
  if command -v rustc &> /dev/null; then
    rustup update stable
    echo "Rust ($(rustc --version))"
  else
    echo "install Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
  fi
}

function error() {
  echo 'error'
  exit 1
}

(
  create_symbolic_links &&
  create_config_symbolic_links &&
  create_bin_symbolic_links &&
  install_rust
) || error
