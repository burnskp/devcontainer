local lazypath = vim.fn.stdpath("data") .. "/minimal/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("config.options")
require("lazy").setup({
  lockfile = vim.fn.stdpath("data") .. "/minimal-lock.json",
  root = vim.fn.stdpath("data") .. "/minimal",
  install = {
    missing = true,
  },
  spec = { { import = "minimal" } },
  checker = { disabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

vim.keymap.set("n", "<leader>P", '"+P', {})
vim.keymap.set("n", "<leader>d", "<cmd>BufferClose<CR>", {})
vim.keymap.set("n", "<leader>c", "<cmd>close<CR>", {})
vim.keymap.set("n", "<leader>p", '"+p', {})
vim.keymap.set("n", "<leader>wo", "<C-w>o", {})
vim.keymap.set("n", "<leader>wp", "<cmd>pclose<cr>", {})
vim.keymap.set("n", "<leader>wz", "<C-w>|<C-w>_", {})
vim.keymap.set("n", "<leader>y", '"+y', {})
vim.keymap.set("n", "ZZ", "<cmd>wqa!<cr>", {})
vim.keymap.set("n", "[l", "<cmd>lprevious<CR>", {})
vim.keymap.set("n", "[q", "<cmd>cprevious<CR>", {})
vim.keymap.set("n", "]l", "<cmd>lnext<CR>", {})
vim.keymap.set("n", "]q", "<cmd>cnext<CR>", {})
