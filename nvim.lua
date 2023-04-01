function toggle_copilot()
  local copilot_enabled = vim.g.copilot_enabled or false
  if copilot_enabled then
    vim.g.copilot_enabled = false
    vim.cmd('echo "Copilot disabled"')
  else
    vim.g.copilot_enabled = true
    vim.cmd('echo "Copilot enabled"')
  end
end

vim.g.copilot_enabled = false
vim.api.nvim_set_keymap('n', 'c', ':lua toggle_copilot()<CR>', { noremap = true, silent = false })
