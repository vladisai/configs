-- Settings carried over from ~/.vimrc, which nvim no longer sources.
-- Plain vim still reads ~/.vimrc; this file is the nvim side of it.
-- Config for plugins that lazy does not install has been dropped: black,
-- YCM, Gundo, snipMate, easytags, chatgpt, codefmt.

local M = {}

function M.setup()
  local home = assert(vim.env.HOME)

  ---------------------------------------------------------------
  -- Options
  ---------------------------------------------------------------
  vim.opt.backspace = { "indent", "eol", "start" }
  vim.opt.backup = true
  vim.opt.history = 50
  vim.opt.ruler = true
  vim.opt.showcmd = true
  vim.opt.incsearch = true
  vim.opt.hlsearch = true
  vim.opt.regexpengine = 1
  vim.opt.mouse = "a"
  vim.opt.autoindent = true
  vim.opt.hidden = true

  vim.opt.number = true
  vim.opt.cursorline = true
  vim.opt.list = true
  vim.opt.listchars = { eol = "•" }
  vim.opt.laststatus = 2
  vim.opt.ttimeoutlen = 50

  vim.opt.tabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.expandtab = true

  vim.opt.foldenable = true
  vim.opt.foldlevelstart = 10
  vim.opt.foldnestmax = 10
  vim.opt.foldmethod = "indent"

  vim.opt.tags = "./tags;"
  vim.opt.tagrelative = false

  -- Shared with plain vim, so the undo history carries across both editors
  vim.opt.undofile = true
  vim.opt.undodir = home .. "/.vim/undo"
  vim.opt.undolevels = 1000
  vim.opt.undoreload = 10000
  vim.opt.backupdir = home .. "/.vim/tmp"
  vim.opt.directory = home .. "/.vim/swap"

  -- 'background' has to be set before the colorscheme at the bottom of this
  -- function, otherwise pettir runs its dark branch and gets sourced twice.
  vim.opt.background = "light"
  vim.opt.termguicolors = true

  -- Order matters and matches .vimrc. With `syntax on` first, the python
  -- ftplugin's `indentkeys-=0#` is undone before indent/python.vim appends to
  -- it, and typing # at the start of a line then reindents it.
  vim.cmd("filetype plugin indent on")
  vim.cmd("syntax on")

  ---------------------------------------------------------------
  -- Autocommands and commands
  ---------------------------------------------------------------
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "text",
    callback = function()
      vim.opt_local.textwidth = 78
    end,
  })

  -- Jump to the last known cursor position
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
        -- Fails when the stored column is past the end of the line
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })

  vim.api.nvim_create_autocmd("CompleteDone", {
    callback = function()
      vim.cmd("pclose")
    end,
  })

  vim.api.nvim_create_user_command("DiffOrig", function()
    vim.cmd("vert new")
    vim.bo.buftype = "nofile"
    vim.cmd("r ++edit #")
    vim.cmd("0d_")
    vim.cmd("diffthis")
    vim.cmd("wincmd p")
    vim.cmd("diffthis")
  end, { desc = "Diff against original file" })

  ---------------------------------------------------------------
  -- Plugin variables
  ---------------------------------------------------------------
  vim.g.python_highlight_all = 1
  vim.g.buffergator_suppress_keymaps = 1
  vim.g.NERDTreeQuitOnOpen = 1
  vim.g.gitgutter_terminal_reports_focus = 0
  -- Elsewhere tagbar and vim-flake8 find ctags and flake8 on PATH.
  if vim.fn.has("mac") == 1 then
    vim.g.tagbar_ctags_bin = "/opt/homebrew/Cellar/ctags/5.8_2/bin/ctags"
    vim.g.flake8_cmd = "/opt/homebrew/bin/flake8"
  end

  vim.g.qf_modifiable = 1
  vim.g.qf_join_changes = 1
  vim.g.qf_write_changes = 1

  vim.g.flake8_show_in_gutter = 1
  vim.g.flake8_show_in_file = 0
  vim.g.flake8_error_marker = "■"
  vim.g.flake8_warning_marker = "•"
  vim.g.flake8_pyflake_marker = "•"
  vim.g.flake8_complexity_marker = "•"
  vim.g.flake8_naming_marker = "•"

  vim.g["airline#extensions#tabline#enabled"] = 1
  vim.g.airline_detect_paste = 1
  vim.g.airline_theme = "sol"
  vim.g.airline_left_sep = ">"
  vim.g.airline_left_alt_sep = "|"
  vim.g.airline_right_sep = "<"
  -- Assigned in one go. Reading vim.g gives a copy, so setting a field on it
  -- would be dropped, and an empty table would reach airline as a list.
  vim.g.airline_symbols = {
    linenr = "¶",
    branch = "/",
    paste = "ρ",
    whitespace = "Ξ",
    readonly = "r",
  }

  vim.cmd([[
    highlight link Flake8_Error      Error
    highlight link Flake8_Warning    Normal
    highlight link Flake8_Complexity Normal
    highlight link Flake8_Naming     Normal
    highlight link Flake8_PyFlake    Normal
  ]])

  ---------------------------------------------------------------
  -- Mappings
  ---------------------------------------------------------------
  -- `map` in .vimrc covers normal, visual, select and operator-pending, and it
  -- leaves the right-hand side remappable. Both are kept here.
  local function map(lhs, rhs)
    vim.keymap.set({ "n", "v", "o" }, lhs, rhs, { remap = true })
  end
  local nmap = function(lhs, rhs) vim.keymap.set("n", lhs, rhs, { noremap = true }) end
  local imap = function(lhs, rhs) vim.keymap.set("i", lhs, rhs, { noremap = true }) end

  map("Q", "gq")
  map(";;", "<C-^>")
  imap("<C-U>", "<C-G>u<C-U>")
  vim.keymap.set("i", "jj", "<Esc>", { remap = true })

  -- Motions and edits
  map("<leader>b", "^")
  map("<leader>e", "$")
  map("<leader>a", "ggvG")
  map("<leader>uc", "^df/^df/")
  map("<leader>da", ":%d<CR>")

  -- Files, buffers, windows
  map("<leader>w", ":w<CR>")
  map("<leader>q", ":q<CR>")
  map("<leader>d", ":bd<CR>")
  map("<leader>v", ":vsplit<CR>")
  map("<leader><leader>", "<C-W><C-W>")
  map("<F3>", "<esc>:w<CR>:bp<CR>")
  map("<F4>", "<esc>:w<CR>:bn<CR>")
  map("<leader>3", "<esc>:w<CR>:bp<CR>")
  map("<leader>4", "<esc>:w<CR>:bn<CR>")

  -- System clipboard
  map("<leader>y", '"+y')
  map("<leader>Y", '"+Y')
  map("<leader>p", '"+p')
  map("<leader>P", '"+P')

  -- Plugin windows
  map("<leader>m", ":BuffergatorToggle<CR>")
  map("<leader>t", ":TagbarOpenAutoClose<CR>")
  map("<leader>.", ":NERDTreeToggle<CR>")
  map("<leader>'", ":NERDTreeFind<CR>")

  -- Flake8 and the quickfix list
  map("<leader>h", ":nohl<CR>:call flake8#Flake8UnplaceMarkers()<CR>")
  map("<space>p", ":call flake8#Flake8()<CR>")
  map("<space>3", ":cp<CR>")
  map("<space>4", ":cn<CR>")
  map("<space>o", ":copen<CR>")
  map("<space>q", ":ccl<CR>")

  -- Push the local tree to devfair. The path is the one from .vimrc, from an
  -- older machine where $HOME was /Users/vladsobal.
  map(
    "<leader>s",
    [[:!clear && rsync -zarv --progress --include="*/" --include="*.ipynb" ]]
      .. [[--include="*.py" --include="*.json" --include="*.sh" --include="*.slurm" ]]
      .. [[--exclude="*" /Users/vladsobal/Work/tdmpc2_public/.  devfair:~/work/tdmpc2_public/.;<CR>]]
  )

  -- Config file
  nmap("<leader>rrc", ":source $MYVIMRC<CR>")
  nmap("<leader>orc", ":vsp $MYVIMRC<CR>")

  -- Make
  nmap("<F10>", ":make! run<CR>")
  nmap("<F11>", ":make! all<CR>")

  -- Insert today's date
  nmap("<F5>", '"=strftime("%d/%m/%y")<CR>P')
  imap("<F5>", '<C-R>=strftime("%d/%m/%y")<CR>')

  ---------------------------------------------------------------
  -- Compile and run, per filetype
  ---------------------------------------------------------------
  -- These are buffer-local, whereas .vimrc set them globally from a FileType
  -- autocommand. Opening one cpp file there left <F9> compiling cpp in every
  -- buffer afterwards.
  local function ft_map(ft, lhs, rhs)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = ft,
      callback = function(args)
        vim.keymap.set("n", lhs, rhs, { buffer = args.buf, noremap = true })
      end,
    })
  end

  imap("<F9>", "<Esc><F9>")
  imap("<F8>", "<Esc><F8>")

  ft_map("c", "<F9>", [[:w<CR>:!gcc "%:p:r".c -Wall -pedantic -std=c99 -o "%:p:r"<CR>]])
  ft_map("c", "<F8>", [[:!clear<CR>:!"%:p:r"<CR>]])

  ft_map("cpp", "<F9>", [[:w<CR>:!clear<CR>:!rm "%:p:r" -f; g++ -O2 -Wall -Wextra -std=c++14 -DDEBUG -o "%:p:r" "%:p"<CR>]])
  ft_map("cpp", "<leader><F9>", [[:w<CR>:!clear<CR>:!clang -Wall -Wextra -pthread -std=c++14 -O3 -lstdc++ "%:p" -o "%:p:r"<CR>]])
  ft_map("cpp", "<F8>", [[:!clear<CR>:!"%:p:r"<CR>]])

  ft_map("cs", "<F9>", [[:w<CR>:!mcs "%:p:r".cs<CR>]])
  ft_map("cs", "<F8>", [[:!mono "%:p:r".exe<CR>]])

  ft_map("java", "<F9>", [[:w<CR>:!clear<CR>:!rm "%:p:r".class -f && javac "%:p"<CR>]])
  ft_map("java", "<F8>", [[:!java "%:r"<CR>]])

  ft_map("ocaml", "<F9>", [[:w<CR>:!ocamlc -o "%:p:r" "%:p:r".ml<CR>]])
  ft_map("ocaml", "<F8>", [[:!"%:p:r"<CR>]])

  ft_map("haskell", "<leader>;", [[:w<CR>:!ghc -o "%:p:r" "%"<CR>]])
  ft_map("haskell", "<leader>r", [[:!clear<CR>:!"%:p:r"<CR>]])

  ft_map("javascript", "<F9>", [[:w<CR>:!node "%"<CR>]])
  ft_map("javascript", "<F8>", [[:w<CR>:!eslint "%"<CR>]])

  ft_map("python", "<leader>r", [[:w<CR>:!python3 "%:p"<CR>]])
  ft_map("sh", "<leader>r", [[:w<CR>:!"%:p"<CR>]])
  ft_map("matlab", "<leader>r", [[:w<CR>:!octave "%"<CR>]])
  ft_map("tex", "<F9>", [[:w<CR>:!xelatex "%:p" && zathura "%:p:r".pdf<CR>]])
  ft_map("markdown", "<F9>", [[:w<CR>:!~/.scripts/md_viewer.py "%"<CR>]])

  ---------------------------------------------------------------
  -- Colorscheme, last so it sees the 'background' set above
  ---------------------------------------------------------------
  vim.cmd.colorscheme("pettir")
end

return M
