vim.pack.add({
  "https://github.com/folke/snacks.nvim",
}, { confirm = false })


require("snacks").setup({
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    preset = {
      header = "",
      keys = {
        { icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "n", desc = "Notes", action = ":Notes" },
        { icon = " ", key = "s", desc = "Search Notes", action = ":NotesGrep" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", padding = 1 },
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2 },
    },
  },
  explorer = {
    enabled = true,
    replace_netrw = true
  },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  picker = {
    enabled = true,
    sources = {
      explorer = {
        auto_close = true,
        layout = { preset = "default", preview = false },
      }
    }
  },
  scope = { enabled = true },
  words = { enabled = false },
})
