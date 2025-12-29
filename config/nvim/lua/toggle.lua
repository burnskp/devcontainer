local function toggle_or_seek(key)
  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  local save_pos = vim.api.nvim_win_get_cursor(0)
  
  local booleans = {
    ["true"] = "false",
    ["false"] = "true",
    ["True"] = "False",
    ["False"] = "True",
    ["TRUE"] = "FALSE",
    ["FALSE"] = "TRUE",
    ["yes"] = "no",
    ["no"] = "yes",
    ["on"] = "off",
    ["off"] = "on",
  }

  -- Build the search pattern
  local keys = {}
  for k, _ in pairs(booleans) do
    table.insert(keys, k)
  end
  local bool_pattern = [[\<\(]] .. table.concat(keys, [[\|]]) .. [[\)\>]]

  -- Find positions
  local bool_pos = vim.fn.searchpos(bool_pattern, 'cnW', line)
  local bool_col = bool_pos[2]
  local num_pos = vim.fn.searchpos([[\d]], 'cnW', line)
  local num_col = num_pos[2]

  if bool_col > 0 and (num_col == 0 or bool_col < num_col) then
    vim.api.nvim_win_set_cursor(0, {line, bool_col - 1})
    local word = vim.fn.expand("<cword>")
    if booleans[word] then
      local new_value = booleans[word]
      vim.cmd("normal! ciw" .. new_value .. "\27")
      vim.api.nvim_win_set_cursor(0, save_pos)
    end
    
  else
    local termcode = vim.api.nvim_replace_termcodes(key, true, false, true)
    vim.api.nvim_feedkeys(vim.v.count1 .. termcode, 'n', false)
  end
end

vim.keymap.set("n", "<C-a>", function() toggle_or_seek("<C-a>") end, { desc = "Toggle bool or increment" })
vim.keymap.set("n", "<C-x>", function() toggle_or_seek("<C-x>") end, { desc = "Toggle bool or decrement" })
