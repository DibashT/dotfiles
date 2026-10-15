-- Markdown note-taking (~/git/wiki) + keymaps.
local wiki = vim.fn.expand("~/git/wiki")

-- Open the most recently edited note, or the index if none exists.
vim.keymap.set("n", "<leader>ww", function()
  local result = vim.fn.systemlist("ls -t " .. wiki .. "/*.md 2>/dev/null | head -1")
  if result and result[1] and result[1] ~= "" then
    vim.cmd("edit " .. result[1])
  else
    vim.cmd("edit " .. wiki .. "/index.md")
  end
  vim.cmd("lcd %:p:h")
end, { desc = "Open last edited wiki file" })

-- Browse notes with oil.
vim.keymap.set("n", "<leader>wo", "<cmd>Oil " .. wiki .. "<CR>", { desc = "Browse wiki" })

-- Create a new note.
vim.keymap.set("n", "<leader>wn", function()
  local name = vim.fn.input("Note name: ")
  if name ~= "" then
    vim.cmd("edit " .. wiki .. "/" .. name .. ".md")
    vim.cmd("lcd %:p:h")
  end
end, { desc = "New note" })

-- Push all notes to git.
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
