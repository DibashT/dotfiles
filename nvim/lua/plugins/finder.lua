-- Fuzzy finder (fzf-lua) + its keymaps.
require("fzf-lua").setup({
  fzf_colors = true,
  winopts = {
    height = 0.95,
    width = 0.90,
    preview = {
      default = "bat",
      delay = 50,
      winopts = { number = false },
    },
  },
  files = {
    formatter = "path.filename_first",
    git_icons = true,
    file_icons = true,
  },
  grep = {
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
    git_icons = true,
    file_icons = true,
  },
  ui_select = true,
  keymap = {
    builtin = {
      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
    },
  },
})

local map = vim.keymap.set
map("n", "<leader><leader>", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Find live grep" })
map("n", "<leader>fr", "<cmd>FzfLua resume<cr>", { desc = "Resume last picker" })
map("n", "<leader>,", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
map("n", "<leader>h", "<cmd>FzfLua keymaps<cr>", { desc = "Show all keymaps" })
map("n", "<leader>fc", "<cmd>FzfLua colorschemes<cr>", { desc = "Pick colorscheme" })
