-- =========================
-- Leader keys (set FIRST)
-- =========================
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Copy file path relative to home (normal: ~/path/file, visual: ~/path/file:L1-L2)
vim.keymap.set('n', '<leader>g', function()
  local path = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':~')
  vim.fn.setreg('+', path)
  print('Copied: ' .. path)
end, { noremap = true })

vim.keymap.set('v', '<leader>g', function()
  local path = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':~')
  local l1 = vim.fn.line('v')
  local l2 = vim.fn.line('.')
  if l1 > l2 then l1, l2 = l2, l1 end
  local result = path .. ':' .. l1 .. '-' .. l2
  vim.fn.setreg('+', result)
  print('Copied: ' .. result)
end, { noremap = true })

-- Open current file in browser (markdown via md2html, others directly)
vim.keymap.set('n', ';m', function()
  local file = vim.fn.expand('%:p')
  local ext = vim.fn.fnamemodify(file, ':e'):lower()
  if ext == 'md' or ext == 'markdown' then
    vim.fn.system('md2html ' .. vim.fn.shellescape(file))
  else
    local opener = vim.fn.has('mac') == 1 and 'open' or 'xdg-open'
    vim.fn.system(opener .. ' ' .. vim.fn.shellescape(file))
  end
end, { noremap = true, silent = true })

-- =========================
-- Settings carried over from ~/.vimrc
-- =========================
require("config.from_vim").setup()

-- =========================
-- Plugin manager (lazy.nvim)
-- =========================
require("config.lazy")

-- =========================
-- Ruff helper commands
-- =========================
vim.api.nvim_create_user_command('RuffFormat', function()
  vim.cmd('silent! !ruff format ' .. vim.fn.expand('%'))
end, {})

vim.api.nvim_create_user_command('FixAll', function()
  vim.cmd('!ruff check --fix ' .. vim.fn.expand('%'))
end, {})

-- Shortcuts for Ruff
vim.api.nvim_set_keymap('n', '<space>t', ':RuffFormat<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>tt', ':FixAll<CR>', { noremap = true, silent = true })


-- =========================
-- Telescope setup
-- =========================

local builtin = require('telescope.builtin')
local rgignore = vim.fn.stdpath('config') .. '/rgignore'

require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--no-ignore-vcs",   -- 👈 key line
      "--ignore-file", rgignore,
    },
  },
})
require("telescope").setup({
  pickers = {
    find_files = {
      hidden = true,
      no_ignore = true,        -- ignore .gitignore/.ignore
      no_ignore_parent = true, -- also ignore parent dirs' ignore files
    },
  },
})
vim.keymap.set("n", "<space>f", function()
  builtin.find_files({
    hidden = true,
    find_command = {
      "rg",
      "--files",
      "--hidden",

      "--no-ignore-vcs",              -- ignore .gitignore
      "--ignore-file", rgignore,
    },
  })
end, { desc = "Telescope find files" })

-- vim.keymap.set('n', '<space>f', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', ',f', builtin.live_grep, { desc = 'Telescope live grep' })

-- =========================
-- LSP keymaps on attach
-- =========================
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  end,
})

-- =========================
-- Diagnostics config
-- =========================
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- =========================
-- Highlight groups
-- (these should come AFTER colorscheme, which is probably in cfg.vim)
-- =========================
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = '#ff6b6b', italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextWarn',  { fg = '#ffd93d', italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextInfo',  { fg = '#6bcf7f', italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextHint',  { fg = '#a8a8a8', italic = true })

vim.api.nvim_set_hl(0, 'Search',    { fg = '#000000', bg = '#f9d992' })
vim.api.nvim_set_hl(0, 'IncSearch', { fg = '#000000', bg = '#f9d992' })
vim.api.nvim_set_hl(0, 'CurSearch', { fg = '#000000', bg = '#f9d992' })

-- =========================
-- nvim-cmp configuration
-- =========================
local cmp = require('cmp')

cmp.setup({
   preselect = cmp.PreselectMode.Item,      -- always have a “top” item
   completion = {
    completeopt = "menu,menuone,noselect", -- ok to keep noselect, ghost still works
    autocomplete = {
      cmp.TriggerEvent.TextChanged,
      cmp.TriggerEvent.InsertEnter,
    },
    keyword_length = 1, -- important: start early, Copilot-ish
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>']     = cmp.mapping.scroll_docs(-4),
    ['<C-f>']     = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>']     = cmp.mapping.abort(),
    ['<Tab>']      = cmp.mapping.confirm({ select = true }),
    -- ['<Tab>']   = cmp.mapping.select_next_item(),
    -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),

  sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 1000 },
      { name = "luasnip",  priority = 750 },
      { name = "buffer",   priority = 500 },
  }),

  experimental = {
    ghost_text = true,
  },
})

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }


-- sorting to make q suggestion first
local function lsp_client_name(entry)
  -- nvim_lsp entries usually have a client object reachable like this.
  local ok, client = pcall(function()
    return entry.source.source.client
  end)
  return (ok and client and client.name) or nil
end


-- =========================
-- New-style LSP config
-- (no require('lspconfig') framework)
-- =========================

-- Capabilities from cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Ruff LSP
vim.lsp.config('ruff', {
  capabilities = capabilities,
  init_options = {
    settings = {
      -- Ruff language server settings (optional)
    },
  },
})

-- Python LSP (pylsp)
vim.lsp.config('pylsp', {
  capabilities = capabilities,
})

-- Enable both servers
vim.lsp.enable({ 'pylsp', 'ruff' })

-- Enable omnifunc for all LSP-attached buffers
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
  end,
})

-- =========================
-- UI options
-- =========================
vim.opt.signcolumn = "no"
vim.opt.number = true

-- Commenting
require('Comment').setup(
    {
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        line = ',cl',
        ---Block-comment toggle keymap
        block = ',cc',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = ',c',
        ---Block-comment keymap
        block = 'gb',
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
    },
    ---Function to call before (un)comment
    pre_hook = nil,
    ---Function to call after (un)comment
    post_hook = nil,
}
)
