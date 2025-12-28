vim.pack.add({
  "https://github.com/folke/sidekick.nvim",
}, { confirm = false })


require("sidekick").setup({
  tools = {
    opencode = {
      cmd = { "opencode" },
      env = {
        OPENCODE_THEME = "catppuccin",
      },
    },
  },
})
