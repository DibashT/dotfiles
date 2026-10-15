-- General editor options (no keymaps/autocmds here).
vim.o.number = true -- Show line numbers
vim.o.relativenumber = true -- Relative line numbers (easier jumping)
vim.o.scrolloff = 10 -- Keep 10 lines above/below cursor
vim.o.sidescrolloff = 10 -- Keep 10 columns left/right of cursor
vim.o.wrap = false -- Don't wrap lines
vim.o.mouse = "a" -- Enable mouse support

vim.o.shiftwidth = 2 -- Size of an indent
vim.o.tabstop = 2 -- Tab width
vim.o.smartindent = true -- Smart indentation
vim.o.expandtab = true -- Use spaces instead of tabs

vim.o.ignorecase = true -- Ignore case in search ...
vim.o.smartcase = true -- ... unless search has capital letters

vim.o.termguicolors = true -- Better colors
vim.o.signcolumn = "yes" -- Always show sign column
vim.o.completeopt = "menuone,noinsert,noselect" -- Completion options
vim.o.spelllang = "en" -- Spell check language
vim.o.confirm = true -- Raise dialog on unsaved buffer
-- vim.opt.colorcolumn = "80" -- Show column at 80 chars
vim.o.updatetime = 200
vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 10
vim.o.splitright = true -- New window to the right
vim.o.splitbelow = true -- New window below
vim.o.undofile = true -- Persistent undo
vim.o.undolevels = 10000 -- Allow traversing much further back
-- vim.o.selection = "inclusive" -- Use inclusive selection
vim.o.wildmode = "longest:full,full" -- Command-line completion mode
vim.o.wildignorecase = true -- Case-insensitive tab completion in commands
-- Prevent text from jarringly shifting when opening splits/floats.
vim.o.splitkeep = "screen"
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.swapfile = false -- Disable swap file
vim.o.autoread = true -- Auto-reload changed files

vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Cursor shape per mode.
vim.o.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50"

-- Sync clipboard with system clipboard (SSH uses OSC52).
vim.schedule(function()
  local is_ssh = vim.env.SSH_TTY or vim.env.SSH_CONNECTION
  if is_ssh then
    vim.g.clipboard = "osc52"
    vim.opt.clipboard = ""
  else
    vim.g.clipboard = nil
    vim.opt.clipboard = "unnamedplus"
  end
end)

-- Diagnostics appearance + auto-show on jump.
vim.diagnostic.config({
  -- underline = false, -- Don't underline errors
  underline = true,
  virtual_text = false, -- Don't show inline text
  severity_sort = true, -- Show most severe first
  update_in_insert = false, -- Don't update while typing
  float = {
    source = "if_many",
    border = "rounded",
  },
  jump = {
    on_jump = function(diagnostic, bufnr)
      if not diagnostic then
        return
      end
      vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
    end,
  },
})
