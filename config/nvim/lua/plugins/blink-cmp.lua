require("blink.cmp").setup({
  cmdline = {
    sources = { "cmdline", "path" },
    keymap = { preset = "inherit" },
    completion = { menu = { auto_show = true } },
  },
  completion = {
    documentation = { auto_show = true },
    list = { selection = { preselect = false } },
  },
  keymap = {
    preset = "default",
    ["<Tab>"] = {
      function(cmp)
        return cmp.select_and_accept()
      end,
      function()
        return require("sidekick").nes_jump_or_apply()
      end,
      "fallback",
    },
    ["<C-k>"] = { "hide_documentation", "show_documentation" },
    ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
  },
  signature = { enabled = true },
  sources = {
    default = { "lsp", "copilot", "path", "buffer" },
    providers = {
      copilot = {
        name = "copilot",
        module = "blink-copilot",
        score_offset = 100,
        async = true,
      },
    },
  },
})
