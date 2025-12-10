return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    ---@module 'snacks'
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {}

    -- Required for `opts.events.reload`
    vim.o.autoread = true
  end,
  keys = {
    { "<A-a>", function() require("opencode").ask("@this: ", { submit = true }) end, desc = "Ask opencode", mode = { "n", "v" } },
    { "<A-x>", function() require("opencode").select() end, desc = "Execute opencode action…", mode = { "n", "v" } },
    { "ga", function() require("opencode").prompt("@this") end, desc = "Add to opencode", mode = { "n", "v" } },
    { "<C-.>", function() require("opencode").toggle() end, desc = "Toggle opencode", mode = { "n", "v" } },
    { "<S-C-f>", function() require("opencode").command("session.half.page.up") end,desc = "opencode half page up", mode = { "n" } },
    { "<S-C-b>", function() require("opencode").command("session.half.page.down") end, desc = "opencode half page down", mode = { "n" } },
  }
}
