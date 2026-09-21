--Set LeadeR
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic Settings
vim.o.number = true                             -- Show line numbers
vim.o.relativenumber = true                     -- Relative line numbers (easier jumping)
vim.o.scrolloff = 10                            -- Keep 10 line below/above cursor line
vim.o.sidescrolloff = 10                        -- Keep 10 line left/right cusrsor line
vim.o.wrap = false                              -- Don't wrap lines
vim.o.mouse = "a"                               -- Enable mouse support

vim.o.shiftwidth = 2                            -- Size of an indent
vim.o.tabstop = 2                               -- Tab width
vim.o.smartindent = true                        -- smart indentation
vim.o.expandtab = true                          -- Use spaces instead of tabs

vim.o.ignorecase = true                         -- Ignore case in search
vim.o.smartcase = true                          -- unless search has capital letters

vim.o.termguicolors = true                      -- Better colors
vim.o.signcolumn = "yes"                        -- Alwasy show sign column
vim.o.completeopt = "menuone,noinsert,noselect" -- Completion options
vim.o.spelllang = "en"                          -- spell check
vim.o.confirm = true                            -- Raise dialog in unsaved buffer
-- vim.opt.colorcolumn = "80"                      -- show column at 80 position char
vim.o.updatetime = 200
vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 10
vim.o.splitright = true              -- Window split
vim.o.splitbelow = true
vim.o.undofile = true                --Persistent undo
vim.o.undolevels = 10000             --allows to safely travesre  much further
-- vim.o.selection = "inclusive"                   --Use inclusive selection
vim.o.wildmode = "longest:full,full" --Completion mode for command-line
vim.o.wildignorecase = true          --Case-sensitive tab completion in commands
vim.o.splitkeep =
'screen'                             --prevents the text from jarringly shifting around when you open horizontal splits or floating windows.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.swapfile = false --Disable swap file to prevent annoying errors
vim.o.autoread = true  --auto reload changes

--Sync clipboards with system clipboards
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

-- Copy to clipboard shortcuts
vim.keymap.set("n", "<leader>cp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy absolute path" })

vim.keymap.set("n", "<leader>cr", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative path" })

-- Cursor shape per mode
vim.o.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50"

--Vim diagnostic
vim.diagnostic.config({
  underline = false,        --dont underline error
  virtual_text = false,     --show most severe error first
  severity_sort = true,     --dont show while typing
  update_in_insert = false, --nice look for floats (using ty and ruff)
  float = {
    source = "if_many",
    border = "rounded",
  },
  jump = { float = true },
})

--Buffer navigation
vim.keymap.set("n", "<leader>bn", "<Cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

--Show diagnostics
vim.keymap.set("n", "<leader>q", vim.diagnostic.open_float, { desc = "Show diagnostic" })
-- Navigate diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
  { desc = "Go to previous error" })
vim.keymap.set("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
  { desc = "Go to next error" })

-- Easily move between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Better command line movements
vim.keymap.set("c", "<C-b>", "<Left>")
vim.keymap.set("c", "<C-f>", "<Right>")
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")
vim.keymap.set("c", "<M-b>", "<S-Left>")
vim.keymap.set("c", "<M-f>", "<S-Right>")

-- Clear seacrh highlight
vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

--Better indenting in Visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

--Better j Behaviour
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line in cursor position" })

--Quick config setting
vim.keymap.set("n", "<leader>rc", "<Cmd>e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })

-- Restore last cursor position when reopening a file
local last_cursor_group = vim.api.nvim_create_augroup("LastCursorGroup", {})
vim.api.nvim_create_autocmd("BufReadPost", {
  group = last_cursor_group,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

--Highlights yanks
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 300 })
  end,
})

vim.loader.enable()

vim.pack.add({
  'https://github.com/ibhagwan/fzf-lua',
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    branch = main,
    build = ":TSUpdate",
  },
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/kdheepak/lazygit.nvim',
  'https://github.com/esmuellert/codediff.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/goolord/alpha-nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  { src = 'https://github.com/saghen/blink.cmp',             version = vim.version.range('1.x') },
  'https://github.com/nvim-lualine/lualine.nvim',
  { src = 'https://github.com/echasnovski/mini.ai',          version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.comment',     version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.move',        version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.surround',    version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.indentscope', version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.pairs',       version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.bufremove',   version = 'stable' },
  { src = 'https://github.com/echasnovski/mini.notify',      version = 'stable' },
'https://github.com/rebelot/kanagawa.nvim',
    'https://github.com/vague-theme/vague.nvim',
})

--Kanagawa apply after 0.12
require('kanagawa').setup({
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none"
        }
      }
    }
  }
})
vim.cmd('colorscheme kanagawa-wave')

--

local setup_treesitter = function()
  local treesitter = require("nvim-treesitter")
  treesitter.setup({})
  local ensure_installed = {
    "vim", "vimdoc", "query", "rust", "c", "cpp", "c_sharp", "go",
    "html", "css", "javascript", "typescript", "tsx", "vue", "svelte",
    "json", "yaml", "toml", "xml", "lua", "markdown", "markdown_inline",
    "python", "bash", "dockerfile", "make", "regex",
    "git_config", "gitcommit", "gitignore", "git_rebase",
  }

  local config = require("nvim-treesitter.config")
  local already_installed = config.get_installed()
  local parsers_to_install = vim.tbl_filter(
    function(parser) return not vim.tbl_contains(already_installed, parser) end,
    ensure_installed
  )

  if #parsers_to_install > 0 then
    vim.defer_fn(function() treesitter.install(parsers_to_install) end, 100)
  end

  local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      local lang = vim.treesitter.language.get_lang(args.match)
      if lang and vim.list_contains(config.get_installed(), lang) then
        vim.treesitter.start(args.buf)
      end
    end,
  })
end

vim.defer_fn(setup_treesitter, 50)

-- Statusline (Lualine)
require("lualine").setup({
  options = {
    theme = "kanagawa",
    component_separators = "|",
    section_separators = { left = "", right = "" },
  },
})

-- Markdown
require("render-markdown").setup({
  render_modes = { 'n', 'c' },
  anti_conceal = { enabled = false },
})

-- Mini Plugins
require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.indentscope").setup({
  draw = { delay = 0, animation = function() return 0 end },
})
require("mini.pairs").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})

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
vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Find live grep" })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua resume<cr>", { desc = "Resume last picker" })
vim.keymap.set("n", "<leader>,", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>h", "<cmd>FzfLua keymaps<cr>", { desc = "Show all keymaps" })

vim.keymap.set('n', '<leader>fc', '<cmd>FzfLua colorschemes<cr>', { desc = 'Pick colorscheme' })

--Web-devicons
require("nvim-web-devicons").setup({})

-- LSP
vim.lsp.enable({
  'ty',     -- also $ uv tool install ty@latest
  'ruff',   -- also $ uv tool install ruff@latest
  'lua_ls', -- also $ brew install lua-language-server
  'ts_ls'
})
vim.keymap.set("n", "gD", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Auto-format ("lint") on save (adapted from neovim docs :help auto-format)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', { clear = true }),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp.fmt', { clear = false }),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

--Blink
require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono'
  },
  signature = {
    enabled = true,
    window = { border = "rounded" },
  },
  completion = {
    list = {
      selection = { preselect = true, auto_insert = true }
    },
    menu = {
      border = 'rounded',
      draw = {
        treesitter = { 'lsp' },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = 'rounded' },
    },
  },
})

-- Dap (debugging)
local dap = require('dap')
dap.adapters.debugpy = function(cb, config) -- also $ uv tool install debugpy@latest
  if config.request == 'attach' then
    cb({
      type = 'server',
      port = config.connect.port,
      host = config.connect.host or '127.0.0.1',
    })
  else
    cb({
      type = 'executable',
      command = 'debugpy-adapter',
    })
  end
end
dap.configurations.python = { -- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
  {
    type = 'debugpy',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    justMyCode = false,
    python = function()
      local root = vim.fs.root(0, '.venv')
      return { root and root .. '/.venv/bin/python' or 'python3' }
    end,
    cwd = function()
      return vim.fs.root(0, '.venv') or vim.fn.getcwd()
    end,
  },
  {
    type = 'debugpy',
    request = 'launch',
    name = 'Pytest current file',
    module = 'pytest',
    args = { '${file}', '-s' },
    justMyCode = false,
    python = function()
      local root = vim.fs.root(0, '.venv')
      return { root and root .. '/.venv/bin/python' or 'python3' }
    end,
    cwd = function()
      return vim.fs.root(0, '.venv') or vim.fn.getcwd()
    end,
  },
  {
    type = 'debugpy',
    request = 'launch',
    name = 'Pytest current file -k',
    module = 'pytest',
    args = function()
      local test_name = vim.fn.input('pytest -k: ')
      return { '${file}', '-s', '-k', test_name }
    end,
    justMyCode = false,
    python = function()
      local root = vim.fs.root(0, '.venv')
      return { root and root .. '/.venv/bin/python' or 'python3' }
    end,
    cwd = function()
      return vim.fs.root(0, '.venv') or vim.fn.getcwd()
    end,
  },
}
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug toggle breakpoint' })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug continue' })
vim.keymap.set('n', '<leader>dq', dap.terminate, { desc = 'Debug terminate' })
-- vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Debug open REPL' })
vim.keymap.set('n', '<leader>dr', function()
  dap.repl.open({ height = 12 }, 'belowright split')
end, { desc = 'Debug open REPL' })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dap-repl',
  callback = function(ev)
    vim.keymap.set('i', '<C-p>', function() require('dap.repl').on_up() end,
      { buffer = ev.buf, desc = 'DAP REPL previous history' })
    vim.keymap.set('i', '<C-n>', function() require('dap.repl').on_down() end,
      { buffer = ev.buf, desc = 'DAP REPL next history' })
  end,
})
vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Debug run last' })
vim.keymap.set({ 'n', 'v' }, '<leader>dh', require('dap.ui.widgets').hover, { desc = 'Debug hover' })
vim.keymap.set('n', '<Down>', dap.step_over, { desc = 'Debug step over' })
vim.keymap.set('n', '<Right>', dap.step_into, { desc = 'Debug step into' })
vim.keymap.set('n', '<Left>', dap.step_out, { desc = 'Debug step out' })
vim.keymap.set('n', '<Up>', dap.restart_frame, { desc = 'Debug restart frame' })

--Oil
require("oil").setup({
  delete_to_trash = true,
  columns = {
    "icon",
    "mtime",
    highlight = "comment"
  },
  view_options = {
    show_hidden = true,
    sort = {
      { "type",  "asc" },
      { "mtime", "desc" },
    }
  },
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- For note taking
local wiki = vim.fn.expand("~/git/wiki")
-- Open wiki index
-- vim.keymap.set("n", "<leader>ww", "<cmd>edit " .. wiki .. "/index.md<CR>:lcd %:p:h<CR>", { desc = "Open wiki index" })
vim.keymap.set("n", "<leader>ww", function()
  local result = vim.fn.systemlist("ls -t " .. wiki .. "/*.md 2>/dev/null | head -1")
  if result and result[1] and result[1] ~= "" then
    vim.cmd("edit " .. result[1])
  else
    vim.cmd("edit " .. wiki .. "/index.md")
  end
  vim.cmd("lcd %:p:h")
end, { desc = "Open last edited wiki file" })

-- Browse wiki with oil
vim.keymap.set("n", "<leader>wo", "<cmd>Oil " .. wiki .. "<CR>", { desc = "Browse wiki" })

-- New note
vim.keymap.set("n", "<leader>wn", function()
  local name = vim.fn.input("Note name: ")
  if name ~= "" then
    vim.cmd("edit " .. wiki .. "/" .. name .. ".md")
    vim.cmd("lcd %:p:h")
  end
end, { desc = "New note" })

-- Search notes (fzf-lua live grep scoped to wiki)

--   require("fzf-lua").live_grep({ cwd = wiki })
-- end, { desc = "Grep wiki" })

-- -- Find note by filename

--   require("fzf-lua").files({ cwd = wiki })
-- end, { desc = "Find wiki file" })


--   vim.cmd("!cd " .. vim.fn.expand("~/git/wiki") .. " && git add . && git commit -m 'update' && git push")
-- end, { desc = "Sync wiki" })
vim.keymap.set("n", "<leader>ws", function()
  vim.fn.jobstart(
    "cd " .. vim.fn.expand("~/git/wiki") .. " && git add . && git commit -m 'update' && git push",
    {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("Wiki synced", vim.log.levels.INFO)
        else
          vim.notify("Wiki sync failed", vim.log.levels.ERROR)
        end
      end,
    }
  )
end, { desc = "Sync wiki" })


local function git_line_history(start_line, end_line)
  start_line, end_line = math.min(start_line, end_line), math.max(start_line, end_line)
  local range = start_line .. ',' .. end_line .. ':' .. vim.fn.expand('%:t')
  local command = { 'git', '-C', vim.fn.expand('%:p:h'), '--no-pager', 'log', '-L', range }
  local output = vim.fn.systemlist(command)
  local command_text = vim.fn.join(vim.tbl_map(vim.fn.shellescape, command), ' ')

  vim.cmd('vnew')
  vim.bo.buftype = 'nofile'
  vim.bo.filetype = 'diff'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.list_extend({ command_text, '' }, output))
  vim.bo.modified = false
end

vim.keymap.set('n', '<leader>g', '<cmd>LazyGit<cr>', { desc = 'Lazygit' })
vim.keymap.set('n', '<leader>gb', function() vim.ui.open(vim.fn.systemlist('git remote get-url origin')[1]) end,
  { desc = 'Open git remote' })
vim.keymap.set('n', '<leader>gl', function()
  git_line_history(vim.fn.line('.'), vim.fn.line('.'))
end, { desc = 'Git line history' })
vim.keymap.set('v', '<leader>gl', function()
  git_line_history(vim.fn.line('v'), vim.fn.line('.'))
end, { desc = 'Git line history' })



-- Codediff (vscode like diffs :))
require("codediff").setup({})
vim.keymap.set('n', '<leader>ru', '<cmd>CodeDiff<cr>', { desc = 'Code diff not staged' })
vim.keymap.set('n', '<leader>rm', '<cmd>CodeDiff main<cr>', { desc = 'Code diff main' })
vim.keymap.set('n', '<leader>rh', '<cmd>CodeDiff HEAD~1<cr>', { desc = 'Code diff previous commit' })
vim.api.nvim_create_autocmd("User", {
  pattern = "CodeDiffOpen",
  callback = function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      vim.wo[win].cursorline = false
    end
  end,
})

-- Neovim home screen
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Header (ASCII Art)
dashboard.section.header.val = {
  [[                                __                ]],
  [[ ___     ___    ___    __  __ /\_\    ___ ___    ]],
  [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
  [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
  [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
  [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}

-- Buttons
dashboard.section.buttons.val = {
  dashboard.button("f", "󰈞  Find File", "<cmd>FzfLua files<CR>"),
  dashboard.button("n", "  New File", "<cmd>ene <BAR> startinsert <CR>"),
  dashboard.button("r", "󰄉  Recent Files", "<cmd>FzfLua oldfiles<CR>"),
  dashboard.button("g", "󰊢  Git (LazyGit)", "<cmd>LazyGit<CR>"),
  dashboard.button("s", "  Settings", "<cmd>e $MYVIMRC<CR>"),
  dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
}

-- Footer (Fixed for Neovim 0.12 native package manager)
local count = #vim.pack.get()
-- Native calculation of total elapsed milliseconds since binary startup
local ms = math.floor(vim.fn.reltimefloat(vim.fn.reltime()) * 1000)
dashboard.section.footer.val = "⚡ Neovim loaded " .. count .. " packages in " .. ms .. "ms"

-- Highlights (Kanagawa compatible)
dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButtons"
dashboard.section.footer.opts.hl = "AlphaFooter"

alpha.setup(dashboard.opts)


