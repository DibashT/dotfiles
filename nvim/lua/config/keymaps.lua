-- General keymaps. Plugin-specific keymaps live with their plugin file.
local map = vim.keymap.set

-- Copy paths to system clipboard.
map("n", "<leader>cp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy absolute path" })

map("n", "<leader>cr", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative path" })

-- Buffer navigation.
map("n", "<leader>bn", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Diagnostics.
map("n", "<leader>q", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Go to previous diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Go to next diagnostic" })
map("n", "[e", function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Go to previous error" })
map("n", "]e", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Go to next error" })

-- Move focus between windows.
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Emacs-like movements in command line.
map("c", "<C-b>", "<Left>")
map("c", "<C-f>", "<Right>")
map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")
map("c", "<M-b>", "<S-Left>")
map("c", "<M-f>", "<S-Right>")

-- Clear search highlight.
map("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Keep visual selection after indenting.
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Keep cursor in place when joining lines.
map("n", "J", "mzJ`z", { desc = "Join line in cursor position" })

-- Quick open of this config folder.
map("n", "<leader>rc", "<cmd>Oil ~/.config/nvim<CR>", { desc = "Open config folder" })

-- File explorer (oil setup in plugins/oil.lua).
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
