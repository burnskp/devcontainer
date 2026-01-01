require("which-key").setup({
  preset = "helix",
  delay = 800,
  spec = {
      { "<leader>a",  group = "AI" },
      { "<leader>f",  group = "Find" },
      { "<leader>g",  group = "Git" },
      { "<leader>l",  group = "LSP" },
      { "<leader>n",  group = "Notes" },
      { "<leader>u",  group = "Toggle" },
      { "<leader>w",  group = "Window" },
  }
})
