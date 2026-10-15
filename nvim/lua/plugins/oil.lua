-- File explorer (oil).
require("oil").setup({
  delete_to_trash = true,
  columns = {
    "icon",
    "mtime",
  },
  view_options = {
    show_hidden = true,
    sort = {
      { "type", "asc" },
      { "mtime", "desc" },
    },
  },
})
