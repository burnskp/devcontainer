vim.pack.add({
  "https://github.com/mfussenegger/nvim-lint",
}, { confirm = false })

local lint = require("lint")

lint.linters_by_ft = {
  markdown = { "markdownlint" },
  zsh = { "zsh" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})
