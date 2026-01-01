vim.pack.add({
  "https://github.com/burnskp/notes.nvim",
  "https://github.com/catppuccin/nvim",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/nvimtools/none-ls-extras.nvim",
  "https://github.com/nvimtools/none-ls.nvim",
  "https://github.com/sindrets/diffview.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
}, { confirm = false })

vim.cmd.colorscheme("catppuccin-latte")

require("nvim-treesitter").install({
  "bash",
  "diff",
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "hcl",
  "helm",
  "json",
  "json5",
  "jsonc",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "python",
  "regex",
  "ssh_config",
  "terraform",
  "toml",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
})

require("snacks").setup({
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    preset = {
      header = "",
      keys = {
        { icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "n", desc = "Notes", action = ":Notes" },
        { icon = " ", key = "s", desc = "Search Notes", action = ":NotesGrep" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", padding = 1 },
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2 },
      { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
    },
  },
  explorer = {
    enabled = true,
    replace_netrw = true,
  },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  picker = {
    enabled = true,
    sources = {
      explorer = {
        auto_close = true,
        layout = { preset = "default", preview = false },
      },
    },
  },
  scope = { enabled = true },
  words = { enabled = false },
})

require("lualine").setup({
  options = {
    section_separators = "",
    component_separators = "",
  },
  sections = {
    lualine_a = { {
      "mode",
      fmt = function(str)
        return str:sub(1, 1)
      end,
    } },
    lualine_c = { "filename" },
    lualine_x = { "diagnostics", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

require("notes").setup({
  notesDir = "~/.local/share/notes/global",
  projectNotesDir = "~/.local/share/notes/project",
  journalDir = "~/.local/share/notes/journal",
})

local nls = require("null-ls")

require("null-ls").setup({
  sources = {
    require("none-ls.formatting.beautysh").with({
      filetypes = { "zsh" },
      extra_args = { "-i", "2" },
    }),
    nls.builtins.diagnostics.markdownlint,
    nls.builtins.diagnostics.zsh,
    nls.builtins.formatting.cbfmt,
    nls.builtins.formatting.markdownlint,
    nls.builtins.formatting.shfmt.with({
      extra_args = { "-ci", "-s", "-i", "2", "-bn", "-sr" },
    }),
  },
})

require("Comment").setup()
require("nvim-surround").setup()

require("gitsigns").setup({
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end)

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end)

    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk)
    map("n", "<leader>hr", gitsigns.reset_hunk)

    map("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end)

    map("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end)

    map("n", "<leader>hS", gitsigns.stage_buffer)
    map("n", "<leader>hR", gitsigns.reset_buffer)
    map("n", "<leader>hp", gitsigns.preview_hunk)
    map("n", "<leader>hi", gitsigns.preview_hunk_inline)

    map("n", "<leader>hb", function()
      gitsigns.blame_line({ full = true })
    end)

    map("n", "<leader>hd", gitsigns.diffthis)

    map("n", "<leader>hD", function()
      gitsigns.diffthis("~")
    end)

    map("n", "<leader>hQ", function()
      gitsigns.setqflist("all")
    end)
    map("n", "<leader>hq", gitsigns.setqflist)

    -- Toggles
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
    map("n", "<leader>tw", gitsigns.toggle_word_diff)

    -- Text object
    map({ "o", "x" }, "ih", gitsigns.select_hunk)
  end,
})
