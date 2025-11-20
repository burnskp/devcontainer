vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("gitcommit-copilotchat", { clear = true }),
  pattern = "COMMIT_EDITMSG",
  once = true,
  callback = function()
    local chat = require("CopilotChat")
    local prompts = require("CopilotChat.prompts").list_prompts()
    local buf = vim.api.nvim_get_current_buf()
    chat.ask(prompts.Commit.prompt, {
      resources = prompts.Commit.resources,
      model = "claude-haiku-4.5",
      headless = true,
      callback = function(response)
        -- Extract content between first code block markers
        local commit_msg = response.content:match("```[%w]*\n(.-)\n?```")
        local lines
        if commit_msg then
          lines = vim.split(commit_msg, "\n", { plain = true })
        else
          lines = { "# Error: Unable to generate commit", "#" }
          for _, line in ipairs(vim.split(response.content, "\n", { plain = true })) do
            table.insert(lines, "# " .. line)
          end
        end
        vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
      end,
    })
    chat.ask(prompts.Review.prompt, {
      resources = prompts.Commit.resources,
      model = "claude-haiku-4.5",
    })
  end,
})
