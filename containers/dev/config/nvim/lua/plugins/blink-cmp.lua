return {
  "saghen/blink.cmp",
  opts = {
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
      ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
    },
  },
}
