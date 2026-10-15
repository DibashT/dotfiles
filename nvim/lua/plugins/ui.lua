-- Look: colorscheme + file icons.
require("kanagawa").setup({
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none",
        },
      },
    },
  },
})
vim.cmd("colorscheme kanagawa-wave")

require("nvim-web-devicons").setup({})
