-- LSP servers, keymaps, and format-on-save.
vim.lsp.enable({
  "ty", -- also $ uv tool install ty@latest
  "ruff", -- also $ uv tool install ruff@latest
  "lua_ls", -- also $ brew install lua-language-server
  "ts_ls",
})

local map = vim.keymap.set
map("n", "gD", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "ca", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Auto-format on save (adapted from :help auto-format).
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", { clear = true }),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if
      not client:supports_method("textDocument/willSaveWaitUntil")
      and client:supports_method("textDocument/formatting")
    then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("my.lsp.fmt", { clear = false }),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})
