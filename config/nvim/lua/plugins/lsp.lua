vim.lsp.enable('actionsls')
vim.lsp.enable('biome')
vim.lsp.enable('copilot')
vim.lsp.enable('docker_language_server')
vim.lsp.enable('golangci_lint_ls')
vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('marksman')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('stylua')
vim.lsp.enable('terraformls')
vim.lsp.enable('yamlls')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

      vim.keymap.set(
        'i',
        '<C-f>',
        vim.lsp.inline_completion.get,
        { desc = 'LSP: accept inline completion', buffer = bufnr }
      )
      vim.keymap.set(
        'i',
        '<C-y>',
        vim.lsp.inline_completion.select,
        { desc = 'LSP: switch inline completion', buffer = bufnr }
      )
    end
  end
})
