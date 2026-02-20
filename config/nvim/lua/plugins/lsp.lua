local lsp_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
  return capabilities
end

local setup = { capabilities = lsp_capabilities() }
local cfg_path = vim.fn.stdpath("config") .. "/after/lsp/"

local wrap_config = function(cfg)
  if cfg == nil then
    return setup
  end
  return vim.tbl_extend("keep", cfg, setup)
end

vim.lsp.config("bashls", wrap_config({}))
vim.lsp.enable("bashls")

vim.lsp.config("gopls", wrap_config(dofile(cfg_path .. "gopls.lua")))
vim.lsp.enable("gopls")

vim.lsp.config("jsonls", wrap_config(dofile(cfg_path .. "jsonls.lua")))
vim.lsp.enable("jsonls")

vim.lsp.config("lua_ls", wrap_config(dofile(cfg_path .. "lua_ls.lua")))
vim.lsp.enable("lua_ls")

vim.lsp.config("marksman", wrap_config({}))
vim.lsp.enable("marksman")

vim.lsp.config("pyright", wrap_config(dofile(cfg_path .. "pyright.lua")))
vim.lsp.enable("pyright")

vim.lsp.config("terraformls", wrap_config({}))
vim.lsp.enable("terraformls")

vim.lsp.config("yamlls", wrap_config(dofile(cfg_path .. "yamlls.lua")))
vim.lsp.enable("yamlls")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("nvim_lsp_keymaps", { clear = true }),
  callback = function(args)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
    end

    map("n", "K", vim.lsp.buf.hover, "LSP hover")
    map("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
    map("n", "gd", vim.lsp.buf.definition, "LSP definition")
    map("n", "gr", vim.lsp.buf.references, "LSP references")

    map("n", "<leader>ld", vim.lsp.buf.definition, "Go to definition")
    map("n", "<leader>lD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "<leader>lr", vim.lsp.buf.references, "References")
    map("n", "<leader>li", vim.lsp.buf.implementation, "Implementation")
    map("n", "<leader>lt", vim.lsp.buf.type_definition, "Type definition")
    map("n", "<leader>lR", vim.lsp.buf.rename, "Rename")
    map("n", "<leader>la", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>lh", vim.lsp.buf.hover, "Hover documentation")
    map("n", "<leader>ls", vim.lsp.buf.signature_help, "Signature help")
    map("n", "<leader>lf", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, "Format buffer")

    map("v", "<leader>la", vim.lsp.buf.code_action, "Code action (range)")
    map("v", "<leader>lf", function()
      require("conform").format({ async = true, lsp_format = "fallback", range = true })
    end, "Format selection")
  end,
})
