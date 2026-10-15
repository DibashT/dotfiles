-- Git: lazygit, line history, and vscode-like diffs.
local helpers = require("config.helpers")
local map = vim.keymap.set

map("n", "<leader>g", "<cmd>LazyGit<cr>", { desc = "Lazygit" })
map("n", "<leader>gb", function()
  vim.ui.open(vim.fn.systemlist("git remote get-url origin")[1])
end, { desc = "Open git remote" })
map("n", "<leader>gl", function()
  helpers.git_line_history(vim.fn.line("."), vim.fn.line("."))
end, { desc = "Git line history" })
map("v", "<leader>gl", function()
  helpers.git_line_history(vim.fn.line("v"), vim.fn.line("."))
end, { desc = "Git line history" })

-- Codediff (vscode-like diffs).
require("codediff").setup({})
map("n", "<leader>ru", "<cmd>CodeDiff<cr>", { desc = "Code diff not staged" })
map("n", "<leader>rm", "<cmd>CodeDiff main<cr>", { desc = "Code diff main" })
map("n", "<leader>rh", "<cmd>CodeDiff HEAD~1<cr>", { desc = "Code diff previous commit" })

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeDiffOpen",
  callback = function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      vim.wo[win].cursorline = false
    end
  end,
})
