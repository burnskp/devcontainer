require("render-markdown").setup({
  code = {
    sign = false,
    width = "block",
    right_pad = 1,
  },
  file_types = { "markdown", "Avante" },
  heading = {
    sign = false,
  },
  completions = {
    lsp = {
      enabled = true,
    },
  },
})

require("snacks")
  .toggle({
    name = "Render Markdown",
    get = function()
      return require("render-markdown.state").enabled
    end,
    set = function(enabled)
      local m = require("render-markdown")
      if enabled then
        m.enable()
      else
        m.disable()
      end
    end,
  })
  :map("<leader>um")
