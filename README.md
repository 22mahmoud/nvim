## ma.nvim

### Requirements

- Latest [neovim](https://github.com/neovim/neovim) build
- Arch Linux (paru installed)/MacOs (brew installed)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)

### Install config

```sh
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

git clone https://github.com/22mahmoud/nvim ~/.config/nvim
cd ~/.config/nvim
./scripts/setup
nvim --noplugin +PkgInstall +qa
nvim --noplugin +TSUpdateSync +qa
```
