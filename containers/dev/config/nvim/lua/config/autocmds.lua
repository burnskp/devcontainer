local augroup = vim.api.nvim_create_augroup("markdown_lists", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "markdown",
  callback = function()
    vim.opt_local.formatoptions:append("r")
    vim.opt_local.comments:prepend("b:-")
  end,
})
