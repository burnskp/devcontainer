local parsers = require("treesitter.parsers")

require("nvim-treesitter.configs").setup({
  ensure_installed = parsers,
  auto_install = false,
  highlight = { enable = true },
  indent = { enable = true },
})
