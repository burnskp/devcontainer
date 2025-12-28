vim.pack.add({
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
}, { confirm = false })

require('lualine').setup({
  options = {
    section_separators = "",
    component_separators = "",
  },
  sections = {
    lualine_a = { { "mode", fmt = function(str) return str:sub(1, 1) end, }, },
    lualine_c = { 'filename', },
    lualine_x = { 'diagnostics', 'filetype', },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})
