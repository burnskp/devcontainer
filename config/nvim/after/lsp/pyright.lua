local has_ruff = vim.fn.executable("ruff") == 1

return {
  settings = {
    pyright = {
      disableOrganizeImports = has_ruff,
    },
    python = {
      analysis = {
        ignore = has_ruff and { "*" } or {},
      },
    },
  },
}
