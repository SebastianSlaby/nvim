-- plugins.lua
vim.cmd [[
  call plug#begin()
  Plug 'tpope/vim-sensible'
  Plug 'ryanoasis/vim-devicons'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'greggh/claude-code.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-tree/nvim-tree.lua'
  call plug#end()
]]


require("nvim-tree").setup({
  view = {
    preserve_window_proportions = true,
    side = "left",
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
})

