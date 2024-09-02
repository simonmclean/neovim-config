# Neovim config

My Neovim config

### Directories

#### after/ftplugin/<filetype>.<extension>

Filetype specific config

#### plugin/

Neovim automatically loads in all these files on startup, before the contents of `lua/`

#### lua/

Loads after the files in `plugin/`

#### vimscript/

Legacy stuff I haven't yet ported to lua

#### vnip

Snippets used by the vsnip plugin. Also legacy, and should be ported to lua






