# Neovim config

This is my Neovim config. There are many like it, but this one is mine 🫡

![](/cat.webp)

### Directories

- `after/ftplugin/[filetype].[extension]` - Filetype specific config
- `plugin/` - Neovim automatically sources these files on startup, after `lua/`
- `lsp/` - Configs for various language servers
- `lua/` - Loads before the files in `plugin/`
- `vsnip/` - Snippets used by the [hrsh7th/vim-vsnip](https://github.com/hrsh7th/vim-vsnip) plugin

### Prerequisites for first time setup

- A patched [Nerd Font](https://www.nerdfonts.com/font-downloads). Currently using Hack Nerd Font, specifically `HackNerdFont-Regular.ttf`
- [ImageMagick](https://imagemagick.org/) for image previews
