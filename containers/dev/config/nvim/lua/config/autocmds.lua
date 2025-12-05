local augroup = vim.api.nvim_create_augroup("markdown_lists", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "markdown",
  callback = function()
    vim.opt_local.formatoptions:append("r")
    vim.opt_local.comments:prepend("b:-")
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    local target_path

    if arg ~= "" then
      target_path = vim.fn.fnamemodify(arg, ":p")
    else
      target_path = vim.fn.getcwd()
    end

    local git_root = vim.fs.root(target_path, ".git")
    if git_root then
      vim.cmd.cd(git_root)
    elseif arg ~= "" then
      if vim.fn.isdirectory(target_path) == 1 then
        vim.cmd.cd(target_path)
      else
        local parent_dir = vim.fs.dirname(target_path)
        vim.cmd.cd(parent_dir)
      end
    end
  end,
})
