# AGENTS.md
Guidance for coding agents working in this Neovim config repository.

## Scope
- Repository type: personal Neovim config (Lua-first, no traditional build/test app stack).
- Main entrypoint: `init.lua`.
- Main code paths:
  - `lua/ma/*.lua`
  - `lsp/*.lua`
  - `after/plugin/*.lua`
  - `after/ftplugin/*.lua`
  - `scripts/*`

## Local Rule Files
- Cursor rules: none found (`.cursor/rules/` and `.cursorrules` are absent).
- Copilot rules: none found (`.github/copilot-instructions.md` is absent).

## Environment Notes
- Config targets modern Neovim APIs (`vim.pack`, `vim.lsp.config`, `vim.system`, etc.).
- Tool bootstrap is handled by `scripts/setup`.
- Style formatting rules are in `stylua.toml`.

## Build / Setup Commands
Run all commands from repository root.

### Initial setup
```sh
./scripts/setup
```
- Installs system dependencies and language tools.
- Supports Darwin (`brew`) and Arch (`yay`) branches.

### Plugin install
- Automatic on first editor start via `vim.pack` prompt/dialog.
- Open Neovim normally:
```sh
nvim
```

### Plugin update
```sh
nvim --headless "+PkgUpdate" +wqa
```
- `PkgUpdate` is created in `lua/ma/plugins.lua`.

## Lint / Format Commands
### Lua format check
```sh
stylua --check .
```

### Lua format apply
```sh
stylua .
```

### Shell lint (when editing setup script)
```sh
shellcheck scripts/setup
```

### Shell format diff (optional)
```sh
shfmt -d scripts/setup
```

## Test Strategy and Commands
There is no formal Lua unit test harness in this repo (`tests/`, `busted`, `plenary`, etc. are not present).
Use headless smoke checks as the practical verification path.

### Full config smoke test
```sh
nvim --headless -u ./init.lua +qa
```

### Health smoke test
```sh
nvim --headless -u ./init.lua "+checkhealth" +qa
```

### Single-module smoke test (closest to "single test")
```sh
nvim --headless -u ./init.lua "+lua require('ma.utils')" +qa
```
- Swap `ma.utils` for the target module, e.g. `ma.lsp`, `ma.autocmds`, `ma.statusline`.
- Useful to catch syntax and module-load errors quickly for one area.

### Single script syntax check
```sh
bash -n scripts/setup
```

## Code Style Guidelines
These conventions are inferred from existing code and should be preserved.

### Lua baseline
- Write for Neovim runtime; avoid standalone Lua assumptions.
- Follow `stylua.toml` exactly:
  - spaces, width 2
  - max line width 100
  - Unix line endings
  - prefer single quotes
  - omit call parentheses when idiomatic

### Imports and module layout
- Place `require` statements at top of file.
- Alias frequently used APIs (`local autocmd = vim.api.nvim_create_autocmd`).
- Reusable modules should use `local M = {}` and `return M`.
- LSP config files commonly return a typed table directly (`---@type vim.lsp.Config`).

### Naming conventions
- File names: `snake_case.lua`.
- Locals/functions: `snake_case`.
- Module require names map to path (`require 'ma.utils'`, `require 'ma.efm.shfmt'`).
- User commands: descriptive PascalCase (`PkgUpdate`, `LspReload`, `LspTypescriptSourceAction`).
- Augroups: descriptive named strings (`UserLspAttach`, `HighlightYank`).

### Types and annotations
- Use EmmyLua annotations when behavior/contracts are non-obvious.
- Prefer `---@param`, `---@return`, `---@class`, `---@field`, `---@type`.
- Keep annotations close to declarations and callbacks.

### Formatting and table style
- Use trailing commas in multiline tables.
- Break long arrays/maps/arg lists over multiple lines.
- Favor explicit local values before nested callbacks when it improves readability.
- Keep simple guard clauses compact (`if not cond then return end`).

### Error handling and resilience
- Prefer early returns over nested conditionals.
- Check LSP capability support before calling feature methods.
- For user-facing failures, use `vim.notify(...)` with appropriate level.
- Use `assert(...)` only when failure is exceptional and should stop flow.
- In async callbacks (`vim.system`, `client:request`), handle `err` and empty results explicitly.
- Use `vim.schedule(...)` before notifying from async contexts when needed.

### Neovim API usage
- Prefer `vim.api.nvim_create_autocmd` + named augroups.
- Scope keymaps/commands/autocmds to buffers where applicable (`{ buffer = bufnr }`).
- Prefer `vim.keymap.set` over legacy map APIs.
- Use built-in `vim.lsp`, `vim.treesitter`, and `vim.fs` utilities before custom wrappers.

### Root detection and project logic
- Keep root detection deterministic and lightweight.
- Reuse established marker sets (`.git`, lockfiles, language-specific markers).
- Reuse helper utilities (e.g. `ma.utils.insert_package_json`) when extending root logic.

### Editing expectations for agents
- Preserve existing UX behavior unless task explicitly requests changes.
- Keep keymap style, command names, diagnostics style, and plugin patterns consistent.
- Avoid introducing new dependencies or framework abstractions without strong justification.
- Keep edits minimal and focused on the touched feature/module.

## Validation Checklist
Run the relevant subset after changes:

1. `stylua --check .`
2. `nvim --headless -u ./init.lua +qa`
3. Single-module smoke test for touched Lua module(s)
4. `shellcheck scripts/setup` if shell script logic changed

If local tooling is missing, report the exact command and failure output.
