-- mini.* plugins.
require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.indentscope").setup({
  draw = {
    delay = 0,
    animation = function()
      return 0
    end,
  },
})
require("mini.pairs").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})
