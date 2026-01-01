require("sidekick").setup({
  cli = {
    mux = {
      enabled = false,
    },
  },
  tools = {
    opencode = {
      cmd = { "opencode" },
      env = {
        OPENCODE_THEME = "catppuccin",
      },
    },
  },
})
