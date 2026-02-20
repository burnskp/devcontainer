require("copilot").setup({
  filetypes = {
    ["*"] = true,
    gitcommit = false,
    gitrebase = false,
    help = false,
    markdown = false,
    text = false,
  },
  panel = { enabled = false },
  suggestion = { enabled = false },
})
