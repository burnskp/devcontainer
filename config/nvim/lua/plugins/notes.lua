vim.pack.add({
  "https://github.com/burnskp/notes.nvim",
}, { confirm = false })

require("notes").setup({
  notesDir = "~/.local/share/notes/global",
  projectNotesDir = "~/.local/share/notes/project",
  journalDir = "~/.local/share/notes/journal",
})
