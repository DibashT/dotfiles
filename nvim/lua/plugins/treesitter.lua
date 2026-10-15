-- Treesitter (deferred so startup stays fast).
local function setup_treesitter()
  local treesitter = require("nvim-treesitter")
  treesitter.setup({})
  local ensure_installed = {
    "vim",
    "vimdoc",
    "query",
    "rust",
    "c",
    "cpp",
    "c_sharp",
    "go",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "vue",
    "svelte",
    "json",
    "yaml",
    "toml",
    "xml",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "bash",
    "dockerfile",
    "make",
    "regex",
    "git_config",
    "gitcommit",
    "gitignore",
    "git_rebase",
  }

  local config = require("nvim-treesitter.config")
  local already_installed = config.get_installed()
  local parsers_to_install = vim.tbl_filter(function(parser)
    return not vim.tbl_contains(already_installed, parser)
  end, ensure_installed)

  if #parsers_to_install > 0 then
    vim.defer_fn(function()
      treesitter.install(parsers_to_install)
    end, 100)
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
