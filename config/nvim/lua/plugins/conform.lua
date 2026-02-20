require("conform").setup({
  formatters_by_ft = {
    json = { "biome" },
    lua = { "stylua" },
    markdown = { "mdformat" },
    ruby = { "rubocop" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    yaml = { "yamlfmt" },
    hcl = { "terraform_fmt" },
    terraform = { "terraform_fmt" },
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
})
