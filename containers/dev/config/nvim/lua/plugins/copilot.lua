return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    sugestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      yaml = true,
    },
  },
}
