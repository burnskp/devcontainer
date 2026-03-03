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
        if vim.b[vim.api.nvim_get_current_buf()].nes_state then
          cmp.hide()
          return (
            require("copilot-lsp.nes").apply_pending_nes()
            and require("copilot-lsp.nes").walk_cursor_end_edit()
          )
        end
        return cmp.select_and_accept()
      end,
      "fallback",
    },
    ["<C-k>"] = { "hide_documentation", "show_documentation" },
    ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
  },
  signature = { enabled = true },
  sources = {
    default = { "avante", "lsp", "copilot", "path" },
    providers = {
      copilot = {
        name = "copilot",
        module = "blink-copilot",
        score_offset = 100,
        async = true,
      },
      avante = {
        module = 'blink-cmp-avante',
        name = 'Avante',
      }
    },
  },
})
