-- Bootstrap: leader first, then modules.
-- See lua/config/* for options/keymaps/autocmds and lua/plugins/* for setup.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.loader.enable()

require("config.helpers")
require("config.options")
require("plugins")
require("plugins.ui")
require("plugins.treesitter")
require("plugins.statusline")
require("plugins.markdown")
require("plugins.mini")
require("plugins.finder")
require("plugins.completion")
require("plugins.lsp")
require("plugins.dap")
require("plugins.oil")
require("plugins.wiki")
require("plugins.git")
require("plugins.dashboard")
require("config.keymaps")
require("config.autocmds")
