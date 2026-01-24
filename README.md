# resolve.nvim

A Neovim plugin for resolving merge conflicts with ease.

## Features

- Automatically detect merge conflicts in buffers
- Semantic highlighting with automatic light/dark theme support
- Navigate between conflicts quickly
- Resolve conflicts with simple commands
- Support for standard 3-way merge and diff3 formats
- View diffs of a single conflict between base and either version in a floating window
- List all conflicts in quickfix window
- Buffer-local keymaps (only active in buffers with conflicts)
- Matchit integration for `%` jumping between conflict markers
- `<Plug>` mappings for easy custom keybinding
- Customisable hooks/callbacks on conflict detection

## Requirements

- Neovim >= 0.9
- [delta](https://github.com/dandavison/delta) - for the diff view feature (optional but recommended)

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "spacedentist/resolve.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "spacedentist/resolve.nvim",
  config = function()
    require("resolve").setup()
  end,
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'spacedentist/resolve.nvim'

lua << EOF
  require("resolve").setup()
EOF
```

## Configuration

Default configuration:

```lua
require("resolve").setup({
  -- Conflict marker patterns (Lua patterns, must match from start of line)
  markers = {
    ours = "^<<<<<<<+",      -- Start of "ours" section
    theirs = "^>>>>>>>+",    -- End of "theirs" section
    ancestor = "^|||||||+",  -- Start of ancestor/base section (diff3)
    separator = "^=======+$", -- Separator between sections
  },
  -- Set to false to disable default keymaps
  default_keymaps = true,
  -- Callback function called when conflicts are detected
  -- Receives: { bufnr = number, conflicts = table }
  on_conflict_detected = nil,
})
```

### Theming and Highlights

The plugin creates four highlight groups for conflict markers, with semantic colours that automatically adapt to light/dark backgrounds:

| Highlight Group | Marker | Dark Theme | Light Theme | Meaning |
|----------------|--------|------------|-------------|---------|
| `ResolveOursMarker` | `<<<<<<<` | Green tint | Light green | Your changes (keep) |
| `ResolveTheirsMarker` | `>>>>>>>` | Blue tint | Light blue | Incoming changes |
| `ResolveSeparatorMarker` | `=======` | Grey | Light grey | Neutral divider |
| `ResolveAncestorMarker` | `\|\|\|\|\|\|\|` | Amber tint | Light amber | Original/base (diff3) |

All markers are displayed in **bold** with normal text colour and a tinted background.

The highlights automatically update when you change colour schemes or toggle between light/dark backgrounds.

#### Customising Highlights

Override the highlight groups in your config to customise the appearance:

```lua
-- After calling setup(), override any highlights you want to change
vim.api.nvim_set_hl(0, "ResolveOursMarker", { bg = "#3d5c3d", bold = true })
vim.api.nvim_set_hl(0, "ResolveTheirsMarker", { bg = "#3d4d5c", bold = true })
vim.api.nvim_set_hl(0, "ResolveSeparatorMarker", { bg = "#4a4a4a", bold = true })
vim.api.nvim_set_hl(0, "ResolveAncestorMarker", { bg = "#5c4d3d", bold = true })
```

Or link to existing highlight groups if you prefer theme-matched colours:

```lua
vim.api.nvim_set_hl(0, "ResolveOursMarker", { link = "DiffAdd" })
vim.api.nvim_set_hl(0, "ResolveTheirsMarker", { link = "DiffChange" })
vim.api.nvim_set_hl(0, "ResolveSeparatorMarker", { link = "NonText" })
vim.api.nvim_set_hl(0, "ResolveAncestorMarker", { link = "DiffText" })
```

## Usage

### Default Keymaps

When `default_keymaps` is enabled (keymaps are buffer-local, only active when conflicts exist):

- `]x` - Navigate to next conflict
- `[x` - Navigate to previous conflict
- `<leader>co` - Choose ours (current changes)
- `<leader>ct` - Choose theirs (incoming changes)
- `<leader>cb` - Choose both (keep both versions)
- `<leader>cB` - Choose both reverse (theirs then ours)
- `<leader>cm` - Choose base/ancestor (diff3 only)
- `<leader>cn` - Choose none (delete conflict)
- `<leader>cq` - List all conflicts in quickfix window
- `<leader>cD` - Show diff in floating window (diff3 only)

### Commands

The plugin provides the following commands:

- `:ResolveNext` - Navigate to next conflict
- `:ResolvePrev` - Navigate to previous conflict
- `:ResolveOurs` - Choose ours version
- `:ResolveTheirs` - Choose theirs version
- `:ResolveBoth` - Choose both versions (ours then theirs)
- `:ResolveBothReverse` - Choose both versions (theirs then ours)
- `:ResolveBase` - Choose base/ancestor version (diff3 only)
- `:ResolveNone` - Choose neither version
- `:ResolveList` - List all conflicts in quickfix
- `:ResolveDetect` - Manually detect conflicts
- `:ResolveDiff` - Show changes made to base in our/their version in floating window (diff3 only)

### Custom Keymaps

If you prefer custom keymaps, disable the default ones and set your own using the `<Plug>` mappings:

```lua
require("resolve").setup({
  default_keymaps = false,
})

-- Example: Set custom keymaps using <Plug> mappings
vim.keymap.set("n", "]c", "<Plug>(resolve-next)", { desc = "Next conflict (Resolve)" })
vim.keymap.set("n", "[c", "<Plug>(resolve-prev)", { desc = "Previous conflict (Resolve)" })
vim.keymap.set("n", "<leader>co", "<Plug>(resolve-ours)", { desc = "Choose ours (Resolve)" })
vim.keymap.set("n", "<leader>ct", "<Plug>(resolve-theirs)", { desc = "Choose theirs (Resolve)" })
vim.keymap.set("n", "<leader>cb", "<Plug>(resolve-both)", { desc = "Choose both (Resolve)" })
vim.keymap.set("n", "<leader>cB", "<Plug>(resolve-both-reverse)", { desc = "Choose both reverse (Resolve)" })
vim.keymap.set("n", "<leader>cm", "<Plug>(resolve-base)", { desc = "Choose base (Resolve)" })
vim.keymap.set("n", "<leader>cn", "<Plug>(resolve-none)", { desc = "Choose none (Resolve)" })
vim.keymap.set("n", "<leader>cD", "<Plug>(resolve-diff)", { desc = "Show diff (Resolve)" })
vim.keymap.set("n", "<leader>cq", "<Plug>(resolve-list)", { desc = "List conflicts (Resolve)" })
```

### Available `<Plug>` Mappings

The following `<Plug>` mappings are always available for custom keybindings:

- `<Plug>(resolve-next)` - Navigate to next conflict
- `<Plug>(resolve-prev)` - Navigate to previous conflict
- `<Plug>(resolve-ours)` - Choose ours version
- `<Plug>(resolve-theirs)` - Choose theirs version
- `<Plug>(resolve-both)` - Choose both versions (ours then theirs)
- `<Plug>(resolve-both-reverse)` - Choose both versions (theirs then ours)
- `<Plug>(resolve-base)` - Choose base version
- `<Plug>(resolve-none)` - Choose neither version
- `<Plug>(resolve-diff)` - Show diff view
- `<Plug>(resolve-list)` - List conflicts in quickfix

**Note:** The default keymaps use `<leader>c` prefix with adjusted keys to avoid conflicts with LazyVim's `<leader>ca` (code actions), `<leader>cl` (LSP info), and `<leader>cd` (line diagnostics).

### Buffer-Local Keymaps

When `default_keymaps` is enabled, keymaps are only set in buffers that contain conflicts. This prevents the keymaps from interfering with other plugins or workflows in files without conflicts.

### Matchit Integration

The plugin integrates with Vim's matchit to allow jumping between conflict markers using `%`. When a buffer contains conflicts, you can press `%` on any marker (`<<<<<<<`, `|||||||`, `=======`, `>>>>>>>`) to jump to the corresponding marker in the conflict.

### Viewing Diffs (diff3 only)

For diff3-style conflicts, you can view diffs showing what each side changed from the base version. This helps understand the actual changes when the differences are subtle or close together.

Press `<leader>cD` (or `:ResolveDiff`) to open a floating window displaying:
- Base ↔ Ours (what your side changed)
- Base ↔ Theirs (what their side changed)

The diff view uses [delta](https://github.com/dandavison/delta) for beautiful syntax highlighting with intra-line change emphasis. Press `q` or `<Esc>` to close the floating window.

### Hooks and Callbacks

You can run custom code when conflicts are detected using the `on_conflict_detected` callback:

```lua
require("resolve").setup({
  on_conflict_detected = function(info)
    -- info.bufnr: buffer number
    -- info.conflicts: table of conflict data
    vim.notify(string.format("Found %d conflicts!", #info.conflicts), vim.log.levels.WARN)

    -- Example: Auto-open quickfix list when conflicts detected
    vim.schedule(function()
      require("resolve").list_conflicts()
    end)
  end,
})
```

## How It Works

When you open a file with merge conflicts, resolve.nvim automatically:

1. Detects conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
2. Highlights the conflicting regions
3. Provides commands to navigate and resolve conflicts

### Conflict Structure

Standard 3-way merge:
```
<<<<<<< HEAD (ours)
Your changes
=======
Their changes
>>>>>>> branch-name (theirs)
```

diff3 style:
```
<<<<<<< HEAD (ours)
Your changes
||||||| ancestor
Original content
=======
Their changes
>>>>>>> branch-name (theirs)
```

## License

MIT
