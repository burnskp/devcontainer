return {
  cmd = { "lua-language-server", "--logpath=~/.cache/lua_ls" },
  settings = {
    Lua = {
      telemetry = { enable = false },
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim", "Snacks", "require" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.stdpath("config") .. "/lua",
        },
      },
    },
  },
}
