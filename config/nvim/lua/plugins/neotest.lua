require("neotest").setup({
  adapters = {
    require("neotest-go"),
    require("neotest-python"),
    require("neotest-vitest"),
    require("neotest-rspec"),
    require("neotest-rust"),
  },
})
