return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = function(_, opts)
    -- Read prompts from ~/.config/nvim/prompts
    local function load_prompts()
      local prompts = {}
      local files = vim.fn.glob(vim.fn.stdpath("config") .. "/prompts/*.txt", false, true)
      for _, path in ipairs(files) do
        local prompt = vim.fn.fnamemodify(path, ":t:r")
        local content = {}
        local f = io.open(path, "r")
        if f then
          content = f:read("*all")
          f:close()
          prompts[prompt] = {
            prompt = content,
          }
        end
      end
      return prompts
    end

    opts.prompts = load_prompts()
    opts.model = "claude-haiku-4.5"
    return opts
  end,
  keys = {
    { "<leader>aa", false },
    { "<leader>ap", false },
    {
      "<leader>ac",
      function()
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>aP",
      function()
        require("CopilotChat").select_prompt()
      end,
      desc = "Prompt Actions (CopilotChat)",
      mode = { "n", "v" },
    },
  },
}
