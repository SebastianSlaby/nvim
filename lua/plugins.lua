-- plugins.lua
vim.cmd [[
  call plug#begin()
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-fugitive'
  Plug 'APZelos/blamer.nvim'
  Plug 'nvim-telescope/telescope-ui-select.nvim'
  Plug 'ryanoasis/vim-devicons'
  Plug 'greggh/claude-code.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': 'master'}
  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'anuvyklack/hydra.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
  Plug 'dstein64/nvim-scrollview'
  Plug 'nvim-tree/nvim-web-devicons' " Recommended (for coloured icons)
  " Plug 'ryanoasis/vim-devicons' Icons without colours
  Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
  Plug 'Exafunction/windsurf.vim', { 'branch': 'main' }
  Plug 'qpkorr/vim-bufkill'
  Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'folke/tokyonight.nvim'
  Plug 'mason-org/mason.nvim'
  Plug 'mason-org/mason-lspconfig.nvim'
  Plug 'm4xshen/autoclose.nvim'
  Plug 'anurag3301/nvim-platformio.lua'
  Plug 'akinsho/nvim-toggleterm.lua'
  Plug 'folke/which-key.nvim'
  call plug#end()
]]

require 'nvim-treesitter.configs'.setup { ... }


vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("tabfirst") -- Returns focus to the first tab
  end,
})




local term = lua
vim.g.blamer_enabled = true
require("toggleterm").setup()


local opts = { noremap = true, silent = true }


local Hydra = require('hydra')
Hydra({
  name = 'Resize windows',
  mode = 'n',
  body = '<leader>r',
  heads = {
    { 'h', '<C-w><', { desc = 'shrink width' } },
    { 'l', '<C-w>>', { desc = 'increase width' } },
    { 'k', '<C-w>+', { desc = 'increase height' } },
    { 'j', '<C-w>-', { desc = 'decrease height' } },
    { 'q', nil,      { exit = true, desc = 'quit' } }
  }
})


local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Default nvim-tree mappings (remove this line if you want *only* custom ones)
  api.config.mappings.default_on_attach(bufnr)

  -- Remove <Tab> mapping
  vim.keymap.del("n", "<Tab>", { buffer = bufnr })

  -- You can add other mappings here as needed
end

require("nvim-tree").setup({
  tab = {
    sync = {
      open = true,
      close = true,
    },
  },
  view = {
    preserve_window_proportions = true,
    side = "left",
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  on_attach = my_on_attach,
})


require("claude-code").setup({
  -- Terminal window settings
  window = {
    split_ratio = 0.6,      -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
    position = "vertical",  -- Position of the window: "botright", "topleft", "vertical", "float", etc.
    enter_insert = true,    -- Whether to enter insert mode when opening Claude Code
    hide_numbers = true,    -- Hide line numbers in the terminal window
    hide_signcolumn = true, -- Hide the sign column in the terminal window

    -- Floating window configuration (only applies when position = "float")
    float = {
      width = "80%",       -- Width: number of columns or percentage string
      height = "80%",      -- Height: number of rows or percentage string
      row = "center",      -- Row position: number, "center", or percentage string
      col = "center",      -- Column position: number, "center", or percentage string
      relative = "editor", -- Relative to: "editor" or "cursor"
      border = "rounded",  -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
    },
  },
  -- File refresh settings
  refresh = {
    enable = true,             -- Enable file change detection
    updatetime = 100,          -- updatetime when Claude Code is active (milliseconds)
    timer_interval = 1000,     -- How often to check for file changes (milliseconds)
    show_notifications = true, -- Show notification when files are reloaded
  },
  -- Git project settings
  git = {
    use_git_root = true, -- Set CWD to git root when opening Claude Code (if in git project)
  },
  -- Shell-specific settings
  shell = {
    separator = '&&',    -- Command separator used in shell commands
    pushd_cmd = 'pushd', -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
    popd_cmd = 'popd',   -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
  },
  -- Command settings
  command = "claude", -- Command used to launch Claude Code
  -- Command variants
  command_variants = {
    -- Conversation management
    continue = "--continue", -- Resume the most recent conversation
    resume = "--resume",     -- Display an interactive conversation picker

    -- Output options
    verbose = "--verbose", -- Enable verbose logging with full turn-by-turn output
  },
  -- Keymaps
  keymaps = {
    toggle = {
      normal = "<C-,>",          -- Normal mode keymap for toggling Claude Code, false to disable
      terminal = "<C-,>",        -- Terminal mode keymap for toggling Claude Code, false to disable
      variants = {
        continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
        verbose = "<leader>cV",  -- Normal mode keymap for Claude Code with verbose flag
      },
    },
    window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
    scrolling = true,         -- Enable scrolling keymaps (<C-f/b>) for page up/down
  }
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.opt.termguicolors = true
require("bufferline").setup {
  options = {
    -- optional: other custom options
  }
}

vim.cmd [[highlight BufferLineIndicatorSelected guifg=#FF7A93 guibg=#24283b gui=underline]]




local map = vim.keymap.set
local opts = { noremap = true, silent = true }



vim.cmd [[colorscheme tokyonight]]


require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "rust_analyzer", "gopls", "jsonls" },
}

--local lspconfig = require('lspconfig')

require("autoclose").setup()

require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--max-columns=1000' -- example tweak
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter = require 'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter = require 'telescope.sorters'.get_generic_fuzzy_sorter,
    path_display = { "absolute" },
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    -- Increase results limit (if applicable)
    max_results = 10000,
  }
}

vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  command = "wincmd =",
})


-- show diagnostics in a floating window under the cursor
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open diagnostics float" })

vim.keymap.set('n', '<leader>q', function()
  vim.diagnostic.setqflist({ open = true })
end, { desc = "Diagnostics → quickfix" })



vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "]q", ":cnext<CR>:wincmd p<CR>", { buffer = true, desc = "Quickfix next (stay in qf)" })
    vim.keymap.set("n", "[q", ":cprev<CR>:wincmd p<CR>", { buffer = true, desc = "Quickfix prev (stay in qf)" })
  end,
})
