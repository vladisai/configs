require('lspconfig').ruff_lsp.setup {
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}

vim.cmd('source ~/.config/nvim/cfg.vim')

vim.api.nvim_create_user_command('RuffFormat', function()
  vim.cmd('silent! !ruff format ' .. vim.fn.expand('%'))
end, {})

vim.api.nvim_create_user_command('FixAll', function()
  vim.cmd('!ruff check --fix ' .. vim.fn.expand('%'))
end, {})

-- Create a shortcut (e.g., <leader>rf) for Ruff formatting
vim.api.nvim_set_keymap('n', '<space>t', ':RuffFormat<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<space>tt', ':FixAll<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
