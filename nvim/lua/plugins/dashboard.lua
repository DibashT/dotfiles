-- Start screen (alpha dashboard).
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Header (slim NVIM logo).
dashboard.section.header.val = {
  [[ ███╗   ██╗██╗   ██╗██╗███╗   ███╗]],
  [[ ████╗  ██║██║   ██║██║████╗ ████║]],
  [[ ██╔██╗ ██║██║   ██║██║██╔████╔██║]],
  [[ ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
  [[ ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║]],
  [[ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]],
}

-- Buttons.
dashboard.section.buttons.val = {
  dashboard.button("f", "󰈞  Find File", "<cmd>FzfLua files<CR>"),
  dashboard.button("n", "  New File", "<cmd>ene <BAR> startinsert <CR>"),
  dashboard.button("r", "󰄉  Recent Files", "<cmd>FzfLua oldfiles<CR>"),
  dashboard.button("g", "󰊢  Git (LazyGit)", "<cmd>LazyGit<CR>"),
  dashboard.button("s", "  Settings", "<cmd>e $MYVIMRC<CR>"),
  dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
}

-- Footer (Neovim 0.12 native package manager).
local count = #vim.pack.get()
-- Native calculation of total elapsed milliseconds since binary startup.
local ms = math.floor(vim.fn.reltimefloat(vim.fn.reltime()) * 1000)
dashboard.section.footer.val = "⚡ Neovim loaded " .. count .. " packages in " .. ms .. "ms"

-- Highlights (Kanagawa Wave).
-- Defined here (after the colorscheme in plugins.ui) so they survive
-- a colorscheme reload and don't rely on undefined defaults.
vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#7E9CD8" }) -- crystalBlue
vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#DCD7BA" }) -- fujiWhite
vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#727169" }) -- fujiGray
dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButtons"
dashboard.section.footer.opts.hl = "AlphaFooter"

alpha.setup(dashboard.opts)
