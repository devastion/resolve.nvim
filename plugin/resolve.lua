-- resolve.nvim plugin entry point
-- This file is automatically sourced by Neovim

-- Prevent loading the plugin twice
if vim.g.loaded_resolve then
  return
end
vim.g.loaded_resolve = true

-- Create user commands
vim.api.nvim_create_user_command("ResolveNext", function()
  require("resolve").next_conflict()
end, { desc = "Navigate to next conflict" })

vim.api.nvim_create_user_command("ResolvePrev", function()
  require("resolve").prev_conflict()
end, { desc = "Navigate to previous conflict" })

vim.api.nvim_create_user_command("ResolveOurs", function()
  require("resolve").choose_ours()
end, { desc = "Choose ours version" })

vim.api.nvim_create_user_command("ResolveTheirs", function()
  require("resolve").choose_theirs()
end, { desc = "Choose theirs version" })

vim.api.nvim_create_user_command("ResolveBoth", function()
  require("resolve").choose_both()
end, { desc = "Choose both versions" })

vim.api.nvim_create_user_command("ResolveBothReverse", function()
  require("resolve").choose_both_reverse()
end, { desc = "Choose both versions (reverse order)" })

vim.api.nvim_create_user_command("ResolveBase", function()
  require("resolve").choose_base()
end, { desc = "Choose base/ancestor version (diff3 only)" })

vim.api.nvim_create_user_command("ResolveNone", function()
  require("resolve").choose_none()
end, { desc = "Choose neither version" })

vim.api.nvim_create_user_command("ResolveList", function()
  require("resolve").list_conflicts()
end, { desc = "List all conflicts in quickfix" })

vim.api.nvim_create_user_command("ResolveDetect", function()
  require("resolve").detect_conflicts()
end, { desc = "Manually detect conflicts" })

vim.api.nvim_create_user_command("ResolveDiff", function()
  require("resolve").show_diff()
end, { desc = "Show conflict diffs in floating window" })
