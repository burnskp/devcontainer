local lint = require("lint")

lint.linters_by_ft = {
  markdown = { "markdownlint" },
  ruby = { "rubocop" },
  sh = { "shellcheck" },
  yaml = { "yamllint" },
  hcl = { "tflint" },
  terraform = { "tflint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})
