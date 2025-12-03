return {
  "folke/sidekick.nvim",
  opts = {
    tools = {
      opencode = {
        cmd = { "opencode" },
        env = {
          OPENCODE_THEME = "catppuccin",
          OPENCODE_MODEL = "github-copilot/claude-haiku-4.5",
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>aa", false },
    { "<leader>as", false },
    { "<leader>ad", false },
    { "<leader>at", false },
    { "<leader>af", false },
    { "<leader>av", false },
    { "<leader>ap", false },
    { "<leader>A", "", desc = "+sidekick", mode = { "n", "v" } },
    {
      "<leader>Ao",
      function() require("sidekick.cli").toggle({ name = "opencode" }) end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>Aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>As",
      function() require("sidekick.cli").select({ filter = { installed = true } }) end,
      desc = "Select CLI",
    },
    {
      "<leader>Ad",
      function() require("sidekick.cli").close() end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>At",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>Af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Send File",
    },
    {
      "<leader>Av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>Ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
  },
}
