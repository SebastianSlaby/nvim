local nvlsp = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

vim.tbl_deep_extend("keep", nvlsp, {
  terramate_ls = {
    cmd = { "terramate-ls" },
    filetypes = "terramate",
    name = "terramate_ls",
  },
})

nvlsp.defaults() -- loads nvchad's defaults
local servers = { "html", "cssls", "gopls", "terraformls", "gitlab_ci_ls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end
