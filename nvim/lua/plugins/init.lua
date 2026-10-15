-- Plugin list (Neovim 0.12 native vim.pack).
-- NOTE: removed vague.nvim (was installed but never used).
-- Run :NvimPackUpdate after this change; the lockfile prunes itself.
vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua",
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
  },
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/kdheepak/lazygit.nvim",
  "https://github.com/esmuellert/codediff.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/goolord/alpha-nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
  "https://github.com/nvim-lualine/lualine.nvim",
  { src = "https://github.com/echasnovski/mini.ai", version = "stable" },
  { src = "https://github.com/echasnovski/mini.comment", version = "stable" },
  { src = "https://github.com/echasnovski/mini.move", version = "stable" },
  { src = "https://github.com/echasnovski/mini.surround", version = "stable" },
  { src = "https://github.com/echasnovski/mini.indentscope", version = "stable" },
  { src = "https://github.com/echasnovski/mini.pairs", version = "stable" },
  { src = "https://github.com/echasnovski/mini.bufremove", version = "stable" },
  { src = "https://github.com/echasnovski/mini.notify", version = "stable" },
  "https://github.com/rebelot/kanagawa.nvim",
})
