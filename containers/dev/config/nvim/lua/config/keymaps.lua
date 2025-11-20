local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("n", "<C-n>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<C-p>", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
map("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show Diagnostics" })

-- Remove gj/gk lazyvim mapping override
vim.keymap.del({ "n", "x" }, "j")
vim.keymap.del({ "n", "x" }, "k")

-- Remove Move Line Up/Down mappings
vim.keymap.del({ "i", "n", "x" }, "<M-j>")
vim.keymap.del({ "i", "n", "x" }, "<M-k>")
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to System Clipboard" })
map("n", "<leader>p", '"+p', { desc = "Paste from System Clipboard" })
map("n", "<leader>P", '"+{', { desc = "Paste from System Clipboard" })
