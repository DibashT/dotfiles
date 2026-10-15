-- Debugging (nvim-dap + debugpy) + keymaps.
local helpers = require("config.helpers")
local dap = require("dap")

-- also $ uv tool install debugpy@latest
dap.adapters.debugpy = function(cb, config)
  if config.request == "attach" then
    cb({
      type = "server",
      port = config.connect.port,
      host = config.connect.host or "127.0.0.1",
    })
  else
    cb({
      type = "executable",
      command = "debugpy-adapter",
    })
  end
end

-- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
dap.configurations.python = {
  {
    type = "debugpy",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    justMyCode = false,
    python = helpers.venv_python,
    cwd = helpers.venv_cwd,
  },
  {
    type = "debugpy",
    request = "launch",
    name = "Pytest current file",
    module = "pytest",
    args = { "${file}", "-s" },
    justMyCode = false,
    python = helpers.venv_python,
    cwd = helpers.venv_cwd,
  },
  {
    type = "debugpy",
    request = "launch",
    name = "Pytest current file -k",
    module = "pytest",
    args = function()
      local test_name = vim.fn.input("pytest -k: ")
      return { "${file}", "-s", "-k", test_name }
    end,
    justMyCode = false,
    python = helpers.venv_python,
    cwd = helpers.venv_cwd,
  },
}

local map = vim.keymap.set
map("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug toggle breakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "Debug continue" })
map("n", "<leader>dq", dap.terminate, { desc = "Debug terminate" })
-- map("n", "<leader>dr", dap.repl.open, { desc = "Debug open REPL" })
map("n", "<leader>dr", function()
  dap.repl.open({ height = 12 }, "belowright split")
end, { desc = "Debug open REPL" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-repl",
  callback = function(ev)
    map("i", "<C-p>", function()
      require("dap.repl").on_up()
    end, { buffer = ev.buf, desc = "DAP REPL previous history" })
    map("i", "<C-n>", function()
      require("dap.repl").on_down()
    end, { buffer = ev.buf, desc = "DAP REPL next history" })
  end,
})

map("n", "<leader>dl", dap.run_last, { desc = "Debug run last" })
map({ "n", "v" }, "<leader>dh", require("dap.ui.widgets").hover, { desc = "Debug hover" })
map("n", "<Down>", dap.step_over, { desc = "Debug step over" })
map("n", "<Right>", dap.step_into, { desc = "Debug step into" })
map("n", "<Left>", dap.step_out, { desc = "Debug step out" })
map("n", "<Up>", dap.restart_frame, { desc = "Debug restart frame" })
