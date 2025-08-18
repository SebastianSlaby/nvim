-- lsp.lua
local lspconfig = require('lspconfig')

lspconfig.gopls.setup({
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})


vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({async = false})
  end
})

local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

require('lspconfig').gopls.setup{
  on_attach = on_attach,
  -- other options...
}


require'nvim-treesitter.configs'.setup {
  highlight = { enable = true },
  ensure_installed = { "go", "lua", "python", "bash", "json", "yaml" }, -- Add your languages here
}
