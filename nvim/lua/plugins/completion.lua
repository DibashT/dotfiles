-- Completion (blink.cmp).
require("blink.cmp").setup({
  keymap = { preset = "default" },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
  },
  signature = {
    enabled = true,
    window = { border = "rounded" },
  },
  completion = {
    list = {
      selection = { preselect = true, auto_insert = true },
    },
    menu = {
      border = "rounded",
      draw = {
        treesitter = { "lsp" },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = "rounded" },
    },
  },
})
