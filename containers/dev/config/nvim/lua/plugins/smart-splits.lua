return {
  "mrjones2014/smart-splits.nvim",
  opts = {},
  keys = {
    {
      "<C-S-h>",
      function()
        require("smart-splits").resize_left()
      end,
      desc = "resize left",
    },
    {
      "<C-S-j>",
      function()
        require("smart-splits").resize_down()
      end,
      desc = "resize down",
    },
    {
      "<C-S-k>",
      function()
        require("smart-splits").resize_up()
      end,
      desc = "resize up",
    },
    {
      "<C-S-l>",
      function()
        require("smart-splits").resize_right()
      end,
      desc = "resize right",
    },
    {
      "<C-h>",
      function()
        require("smart-splits").move_cursor_left()
      end,
      desc = "move left",
    },
    {
      "<C-j>",
      function()
        require("smart-splits").move_cursor_down()
      end,
      desc = "move down",
    },
    {
      "<C-k>",
      function()
        require("smart-splits").move_cursor_up()
      end,
      desc = "move up",
    },
    {
      "<C-l>",
      function()
        require("smart-splits").move_cursor_right()
      end,
      desc = "move right",
    },
    {
      "<C-\\>",
      function()
        require("smart-splits").move_cursor_previous()
      end,
      desc = "move previous",
    },
    {
      "<leader><leader>h",
      function()
        require("smart-splits").swap_buf_left()
      end,
      desc = "swap buffer left",
    },
    {
      "<leader><leader>j",
      function()
        require("smart-splits").swap_buf_down()
      end,
      desc = "swap buffer down",
    },
    {
      "<leader><leader>k",
      function()
        require("smart-splits").swap_buf_up()
      end,
      desc = "swap buffer up",
    },
    {
      "<leader><leader>l",
      function()
        require("smart-splits").swap_buf_right()
      end,
      desc = "swap buffer right",
    },
  },
}
