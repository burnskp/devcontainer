require("which-key").setup({
  preset = "helix",
  delay = 800,
  spec = {
    { "<leader>a", group = "Avante" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>k", group = "Sidekick" },
    { "<leader>l", group = "LSP" },
    { "<leader>u", group = "Toggle" },
    { "<leader>w", group = "Window" },
  },
})
