require("blink.cmp").setup({
  cmdline = {
    keymap = { preset = "inherit" },
    completion = { menu = { auto_show = true } },
  },
  completion = {
    documentation = { auto_show = false },
    list = {
      selection = {
        preselect = function()
          return not require("blink.cmp").snippet_active({ direction = 1 })
        end,
      },
    },
  },
  keymap = {
    preset = "super-tab",
    ["<Tab>"] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      "snippet_forward",
      function() -- sidekick next edit suggestion
        return require("sidekick").nes_jump_or_apply()
      end,
      function()
        return vim.lsp.inline_completion.get()
      end,
      "fallback",
    },
    ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
  },
  signature = { enabled = true },
  sources = {
    default = { "snippets", "lsp", "path", "buffer" },
  },
})
