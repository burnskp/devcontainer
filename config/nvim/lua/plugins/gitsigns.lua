require("gitsigns").setup({
  current_line_blame = false,
  signs = { add = { text = "+" }, change = { text = "~" }, delete = { text = "_" } },
})
