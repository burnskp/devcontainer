vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range('~1') },
}, { confirm = false })

require("blink.cmp").setup({
  completion = {
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
    ['<Tab>'] = {
      function(cmp)
        if cmp.snippet_active() then return cmp.accept()
        else return cmp.select_and_accept() end
      end,
      'snippet_forward',
      function() -- sidekick next edit suggestion
        return require("sidekick").nes_jump_or_apply()
      end,
      function() -- if you are using Neovim's native inline completions
        return vim.lsp.inline_completion.get()
      end,
      'fallback'
    },
    ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
  },
})
