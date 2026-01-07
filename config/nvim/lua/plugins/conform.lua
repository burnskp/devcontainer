require("conform").setup({
  formatters_by_ft = {
    markdown = { "markdownlint-cli2" },
    packer = { "packer_fmt" },
    sh = { "shfmt" },
    zsh = { "shfmt" },
  },
  formatters = {
    shfmt = {
      prepend_args = { "-ci", "-s", "-i", "2", "-bn", "-sr" },
    },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
  format_after_save = {
    lsp_format = "fallback",
  },
})

vim.keymap.set("n", "<leader>uf", function()
  if vim.g.disable_autoformat then
    vim.g.disable_autoformat = false
    print("Autoformat Enabled (Global)")
  else
    vim.g.disable_autoformat = true
    print("Autoformat Disabled (Global)")
  end
end, { desc = "Toggle Autoformat" })
