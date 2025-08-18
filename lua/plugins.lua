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
  Plug 'waiting-for-dev/ergoterm.nvim'
  call plug#end()
]]


require("nvim-tree").setup({
  tab = {
    sync = {
      open = true,   -- open nvim-tree automatically on tab switch
      close = true,  -- close nvim-tree automatically when leaving tab
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
})


vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})


require("ergoterm").setup()






local opts = { noremap = true, silent = true }
