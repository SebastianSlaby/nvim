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
  Plug 'anuvyklack/hydra.nvim'
  call plug#end()
]]


vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
      vim.cmd("tabnew")        -- Creates a new tab
      vim.cmd("terminal")      -- Opens default shell in terminal in this tab
      vim.cmd("tabfirst")      -- Returns focus to the first tab
  end,
})


require("ergoterm").setup()






local opts = { noremap = true, silent = true }


local Hydra = require('hydra')
Hydra({
  name = 'Resize windows',
  mode = 'n',
  body = '<leader>r',
  heads = {
    { 'h',  '<C-w><', { desc = 'shrink width' } },
    { 'l',  '<C-w>>', { desc = 'increase width' } },
    { 'k',  '<C-w>+', { desc = 'increase height' } },
    { 'j',  '<C-w>-', { desc = 'decrease height' } },
    { 'q',  nil,      { exit = true, desc = 'quit' } }
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
