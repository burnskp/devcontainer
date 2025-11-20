return {
  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = "true",
    opts = {
      check_ts = true,
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      ignored_next_char = [=[[#%w%%%'%[%"%.%`%$]]=],
      fast_wrap = {},
    },
  },
}
