# Codex Repo Notes (Neovim Config)

This file is the primary orientation note for this repository.

## Repository Snapshot

- Base: Kickstart-style Neovim config.
- Main entrypoint: `init.lua`.
- Custom layer:
  - `lua/custom/init.lua`
  - `lua/custom/keybindings.lua`
  - `lua/custom/plugins/*.lua`
- Plugin manager: `lazy.nvim`.
- Lockfile: `lazy-lock.json`.

## Important Local Conventions

- Core plugin specs are in `init.lua`.
- Custom plugin overrides/extensions are in `lua/custom/plugins`.
- Prefer avoiding duplicate plugin specs for the same plugin across `init.lua` and `lua/custom/plugins/*` unless intentional and carefully merged.

## Session History / Previous Work

For a full, chronological record of what was changed and debugged in this repository, read:

- `CODEX_WORK_LOG.md`

This is the source of truth for prior Codex troubleshooting and applied fixes.

