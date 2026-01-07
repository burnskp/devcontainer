local packer_severity_to_diagnostic_severity = {
  warning = vim.diagnostic.severity.WARN,
  error = vim.diagnostic.severity.ERROR,
}

return function()
  return {
    cmd = 'packer',
    args = { 'validate' },
    append_fname = true,
    stdin = false,
    stream = 'both',
    ignore_exitcode = true,
    parser = function(output, bufnr)
      local diagnostics = {}
      
      for line in output:gmatch('[^\n]+') do
        -- Match error/warning patterns from packer validate output
        -- Typical format: Error/Warning: <file>:<line>:<col>: <message>
        local severity_str, filename, lnum, col, message = line:match('(%w+):%s*(.+):(%d+):(%d+):%s*(.+)')
        
        if severity_str and filename and lnum and col and message then
          local severity = packer_severity_to_diagnostic_severity[severity_str:lower()] or vim.diagnostic.severity.ERROR
          
          table.insert(diagnostics, {
            message = message:gsub('^%s+|%s+$', ''), -- trim whitespace
            lnum = tonumber(lnum) - 1,
            col = tonumber(col) - 1,
            source = 'packer validate',
            severity = severity,
          })
        end
      end
      
      return diagnostics
    end,
  }
end
