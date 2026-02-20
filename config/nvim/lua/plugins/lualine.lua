require("lualine").setup({
  options = {
    section_separators = "",
    component_separators = "",
  },
  sections = {
    lualine_a = { {
      "mode",
      fmt = function(str)
        return str:sub(1, 1)
      end,
    } },
    lualine_b = { "branch", "diff" },
    lualine_c = { "filename" },
    lualine_x = { "diagnostics", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  tabline = {
    lualine_a = {
      { "buffers", show_filename_only = true, show_modified_status = true, symbols = { modified = " +" } },
    },
  },
})
