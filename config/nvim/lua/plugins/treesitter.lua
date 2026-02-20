local parsers = require("treesitter.parsers")

require("nvim-treesitter.configs").setup({
  ensure_installed = parsers,
  highlight = { enable = true },
  indent = { enable = true },
  textobjects = {
    move = {
      enable = true,
      goto_next_start = {
        ["]a"] = "@parameter.outer",
        ["]b"] = "@block.outer",
        ["]c"] = "@class.outer",
        ["]f"] = "@function.outer",
      },
      goto_previous_start = {
        ["[a"] = "@parameter.outer",
        ["[b"] = "@block.outer",
        ["[c"] = "@class.outer",
        ["[f"] = "@function.outer",
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        aa = "@parameter.outer",
        ab = "@block.outer",
        ac = "@class.outer",
        af = "@function.outer",
        ia = "@parameter.inner",
        ib = "@block.inner",
        ic = "@class.inner",
        ["if"] = "@function.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = { ["<leader>sa"] = "@parameter.inner" },
      swap_previous = { ["<leader>sA"] = "@parameter.inner" },
    },
  },
})

require("treesitter-context").setup({ max_lines = 3, min_window_height = 20 })
