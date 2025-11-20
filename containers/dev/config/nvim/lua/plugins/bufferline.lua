return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        style_preset = require("bufferline").style_preset.no_italic,
        themable = true,
        indicator = { style = "none" },
        buffer_close_icon = "",
        close_icon = "",
        show_buffer_icons = false,
        always_show_bufferline = true,
      },
    },
  },
}
