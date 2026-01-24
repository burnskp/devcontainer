require("which-key").setup({
  preset = "helix",
  delay = 800,
  spec = {
    { "<leader><leader>", group = "Smart Splits" },
    { "<leader>a", group = "Avante" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>h", group = "GitSigns" },
    { "<leader>k", group = "Sidekick" },
    { "<leader>l", group = "LSP" },
    { "<leader>n", group = "Notes" },
    { "<leader>u", group = "Toggle" },
    { "<leader>uN", group = "Noice" },
    { "<leader>w", group = "Window" },
  },
})
