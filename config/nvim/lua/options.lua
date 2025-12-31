vim.g.mapleader = " "

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
  },
}

vim.opt.autowrite = true
vim.opt.expandtab = true
vim.opt.grepprg = "rg --vimgrep"
vim.opt.hlsearch = false
vim.opt.linebreak = true
vim.opt.mouse = ""
vim.opt.number = false
vim.opt.scrolloff = 5
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showmatch = true
vim.opt.showmode = false
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.spelllang = "en_us"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.titlestring = "n:%t"
vim.opt.title = true
vim.opt.wrap = true

-- Set backup options
vim.opt.backup = false
vim.opt.writebackup = false

-- Undo settings
vim.opt.undodir = vim.fn.expand("~/.cache/nvim/undo")
vim.opt.undofile = true

-- disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- default editorconfig
vim.g.editorconfig = {}
vim.g.editorconfig.trim_trailing_whitespace = true
vim.g.editorconfig.tab_width = 2
