-- Shared helpers (no plugin setup here).
local M = {}

-- Prefer the project .venv python, fall back to system python.
function M.venv_python()
  local root = vim.fs.root(0, ".venv")
  return root and root .. "/.venv/bin/python" or "python3"
end

function M.venv_cwd()
  return vim.fs.root(0, ".venv") or vim.fn.getcwd()
end

-- Show git -L line/range history in a scratch diff buffer.
function M.git_line_history(start_line, end_line)
  start_line, end_line = math.min(start_line, end_line), math.max(start_line, end_line)
  local range = start_line .. "," .. end_line .. ":" .. vim.fn.expand("%:t")
  local command = { "git", "-C", vim.fn.expand("%:p:h"), "--no-pager", "log", "-L", range }
  local output = vim.fn.systemlist(command)
  local command_text = vim.fn.join(vim.tbl_map(vim.fn.shellescape, command), " ")

  vim.cmd("vnew")
  vim.bo.buftype = "nofile"
  vim.bo.filetype = "diff"
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.list_extend({ command_text, "" }, output))
  vim.bo.modified = false
end

return M
