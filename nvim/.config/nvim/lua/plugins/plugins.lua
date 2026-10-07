return {
    {
      "nvim-telescope/telescope.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("telescope").setup({})
      end,
  },
  -- LSP
  { "neovim/nvim-lspconfig" },

  -- Treesitter. The main branch is the one that supports Neovim 0.12; master
  -- passes capture lists to its own query directives and crashes on parse.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local languages = {
        "bash", "c", "cpp", "css", "csv", "diff", "dockerfile", "git_config",
        "git_rebase", "gitcommit", "gitignore", "go", "html", "ini", "java",
        "javascript", "json", "latex", "lua", "luadoc", "make", "markdown",
        "markdown_inline", "python", "query", "regex", "requirements", "rust",
        "sql", "toml", "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
      }

      local ts = require("nvim-treesitter")
      ts.setup()
      -- Already-installed parsers are skipped, so this is cheap after the
      -- first run.
      ts.install(languages)

      -- On the main branch highlighting is per buffer and opt-in.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterHighlight", {}),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if lang and vim.treesitter.language.add(lang) then
            vim.treesitter.start(ev.buf, lang)
          end
        end,
      })
    end,
  },

  -- Ghost text input
  { "subnut/nvim-ghost.nvim" },

  -- Goyo distraction-free mode
  { "junegunn/goyo.vim" },

  -- Completion engine
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },

  -- Snippets
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- HuggingFace LLM plugin
  { "huggingface/llm.nvim" },

  -- Git diff/merge viewer
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    config = function()
      require("diffview").setup({})
    end,
  },

  -- File-type icons
  { "nvim-tree/nvim-web-devicons", opts = {} },
  -- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        }
    },

  -- Markdown rendering
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
