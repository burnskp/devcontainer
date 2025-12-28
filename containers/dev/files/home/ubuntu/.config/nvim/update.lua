print("Sync: Treesitter")
local treesitter = lazy.plugins["nvim-treesitter"]
local treesitter_apps = treesitter._.cache.opts.ensure_installed
print(vim.inspect(treesitter_apps))

require("nvim-treesitter").install(treesitter_apps):wait(300000)
require("nvim-treesitter").update():wait(300000)
