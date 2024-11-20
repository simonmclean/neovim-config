#!/bin/bash

latest_version=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r .tag_name)
current_version=$(nvim --version | head -n 1 | awk '{print $2}')
if [ "$latest_version" != "$current_version" ]; then
  echo "Neovim update available: $current_version -> $latest_version"
else
  echo "Neovim is up to date"
fi
