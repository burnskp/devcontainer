return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "cbfmt",
        "fixjson",
        "mdformat",
        "shellharden",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["*"] = { "trim_whitespace" },
        json = { "fixjson" },
        markdown = { "mdformat", "markdownlint-cli2", "markdown-toc", "cbfmt" },
        ["markdown.mdx"] = { "mdformat", "markdownlint-cli2", "markdown-toc", "cbfmt" },
        zsh = { "shfmt" },
      },
      formatters = {
        sfmt = {
          prepend_args = { "-ci", "-s", "-i", "2", "-bn", "-sr" },
        },
      },
    },
  },
}
