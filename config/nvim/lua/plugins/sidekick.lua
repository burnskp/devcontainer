require("sidekick").setup({
  cli = {
    mux = { backend = "tmux", create = "window", enabled = true },
    watch = true,
    win = { layout = "right", split = { width = 80 } },
  },
  nes = {
    debounce = 100,
    diff = { inline = "words" },
    enabled = function(buf)
      local disabled = { markdown = true, text = true, gitcommit = true, gitrebase = true, help = true }
      if disabled[vim.bo[buf].filetype] then
        return false
      end
      return vim.bo[buf].buftype == ""
    end,
  },
})
