> [!CAUTION]
> This repository is archived and has been migrated to my self-hosted git server at
> [git.mahmoudashraf.dev/22mahmoud/nvim](https://git.mahmoudashraf.dev/22mahmoud/nvim).

# ⚡ ma.nvim

> A Lua-first Neovim config focused on performance and native APIs.

![screenshot](screenshot.png)

Personal Neovim config focused on built-in APIs (`vim.pack`, `vim.lsp`, treesitter) with a small plugin set.

### Requirements

- Recent [Neovim](https://github.com/neovim/neovim) with `vim.pack` and `vim.lsp.config` support
- Linux (Arch with `yay`) or macOS (with `brew`) for `scripts/setup`
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- `curl` + `jq` (used by the GraphQL helper)

### Install

```sh
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

git clone https://github.com/22mahmoud/nvim ~/.config/nvim
~/.config/nvim/scripts/setup
nvim
```

Plugin install is handled automatically by `vim.pack` on first startup.

### Update Plugins

```sh
nvim --headless "+PkgUpdate" +wqa
```

### What's Included

- ⚙️ Lean Lua-first setup tuned for speed
- 📦 Uses built-in Neovim package manager (`vim.pack`) via `lua/ma/plugins.lua`
- 🧠 Built-in LSP pipeline with `vim.lsp.enable(...)` and native completion
- 🌳 Treesitter + textobjects setup for better syntax and text objects
- 📁 File explorer workflow via `oil.nvim` on `<leader>e`
- 🎨 Custom statusline + winbar in `lua/ma/statusline.lua`
- 💊 Custom GraphQL runner for `.graphql` buffers on `<kbd>,</kbd> + <kbd>e</kbd>`
  [![asciicast](https://asciinema.org/a/696741.svg)](https://asciinema.org/a/696741)

### Deprecation Notes

Old notes kept for historical context:

- using this wrapper [pkg-manager.lua](https://github.com/22mahmoud/nvim/blob/aab4c0e97227130ca9756fb10d4f078ea806155b/lua/ma/pkg-manager.lua), so you can add new plugin with ```lua use 'neovim/lspconfig' ```
- and a custom [script](https://github.com/22mahmoud/nvim/blob/8a4e98dd572db66ba7b035a769ce8a423c8f67b6/lua/ma/cmp.lua) to add auto-import functionality when insert from LSP omni completion
