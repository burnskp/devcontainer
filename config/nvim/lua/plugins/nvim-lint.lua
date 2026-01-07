local lint = require("lint")

lint.linters_by_ft = {
  markdown = { "markdownlint-cli2" },
  zsh = { "zsh" },
  hcl = { "packer_validate" },
}

lint.linters.packer_validate = require("lint.linters.packer_validate")()

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})
