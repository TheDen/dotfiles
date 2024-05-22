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

vim.g.copilot_enabled = true
vim.api.nvim_set_keymap('n', 'c', ':lua toggle_copilot()<CR>', { noremap = true, silent = false })

on_attach = function(client)
    apply_settings()
    lsp_status.on_attach(client)
    vim.api.nvim_buf_set_keymap(0, 'n', 'gs', '<Cmd>ClangdSwitchSourceHeader<CR>', {noremap=true, silent=true})
end

require("bat").setup {
    background = {
    light = "latte",
    dark = "mocha"
  }
}
