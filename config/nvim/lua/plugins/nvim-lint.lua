local lint = require("lint")

lint.linters_by_ft = {
  markdown = { "markdownlint-cli2" },
  zsh = { "zsh" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})
