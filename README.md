# Neovim config

This is my Neovim config. There are many like it, but this one is mine 🫡

![](/cat.webp)

### Directories

- `after/ftplugin/[filetype].[extension]` - Filetype specific config
- `plugin/` - Neovim automatically sources these files on startup, after `lua/`
- `lua/` - Loads before the files in `plugin/`
- `vimscript/` - Legacy stuff I haven't yet ported to lua
- `vnip/` - Snippets used by the [hrsh7th/vim-vsnip](https://github.com/hrsh7th/vim-vsnip) plugin. Also legacy, and should be ported to lua

### Prerequisites for first-time setup

- Install a patched (Nerd Font)[https://www.nerdfonts.com/font-downloads]. Currently using Hack Nerd Font, specifically `HackNerdFont-Regular.ttf`
