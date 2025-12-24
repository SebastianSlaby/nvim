-- lsp.lua
local navic = require("nvim-navic")

-- Common on_attach function to attach navic to LSP clients
local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

-- Helper for root_dir
local function root_pattern(markers)
  return function(fname)
    return vim.fs.root(fname, markers)
  end
end

vim.lsp.config('lua_ls', { on_attach = on_attach })
vim.lsp.config('gopls', { on_attach = on_attach })
vim.lsp.config('jsonls', { on_attach = on_attach })
vim.lsp.config('terraformls', { on_attach = on_attach })
vim.lsp.config('yamlls', {
  on_attach = on_attach,
  settings = {
    yaml = {
      schemas = {
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] =
        "/.gitlab-ci.yml"
      },
      validate = true,
      completion = true,
      hover = true,
    }
  },
  filetypes = { "yaml", "yaml.gitlab" }
})


vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end
})

vim.filetype.add {
  extension = {
    jinja = 'jinja',
    jinja2 = 'jinja',
    j2 = 'jinja',
  },
  filename = {
    ['.gitlab-ci.yml'] = 'yaml.gitlab',
  },
  pattern = {
    ['.*%.gitlab%-ci%.ya?ml'] = 'yaml.gitlab',
  },
}

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.lsp.config('jinja_lsp', {
  name = "jinja-lsp",
  cmd = { 'jinja-lsp' },
  filetypes = { 'jinja' },
  root_dir = function(fname)
    return '.' -- or use a more sophisticated root dir detection
  end,
  init_options = {
    templates = './templates', -- your templates folder
    backend = { './src' },     -- backend directory if applicable
    lang = "rust"              -- or "python" depending on your backend
  },
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('terramate_ls', {
  cmd = { "terramate-ls" },
  filetypes = { "hcl", "terramate" },
  root_dir = root_pattern({"terramate.tm.hcl", ".git"}),
  on_attach = on_attach,
})

-- Keymaps
-- Note: opts is undefined in original file, preserving behavior (nil)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

-- nvim-treesitter setup
require('nvim-treesitter').setup({})

-- Install parsers
local parsers_to_install = { "c", "go", "python", "bash", "json", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "terraform", "hcl" }

-- Only install if missing to avoid startup messages
local ts_config = require('nvim-treesitter.config')
local installed_parsers = ts_config.get_installed()
local missing_parsers = {}
for _, parser in ipairs(parsers_to_install) do
  if not vim.tbl_contains(installed_parsers, parser) then
    table.insert(missing_parsers, parser)
  end
end

if #missing_parsers > 0 then
  pcall(function() require('nvim-treesitter').install(missing_parsers) end)
end

-- Enable highlighting and indent
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local buf = args.buf
    
    -- Disable for large files
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return
    end

    -- Disable for specific languages
    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype) or vim.bo[buf].filetype
    local disabled_langs = { "c", "rust" }
    if vim.tbl_contains(disabled_langs, lang) then
      return
    end

    -- Start treesitter highlighting
    pcall(vim.treesitter.start, buf, lang)

    -- Enable indent
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

vim.diagnostic.config({
  virtual_text = true,      -- show inline diagnostic text
  signs = true,             -- keep gutter signs W/H/etc.
  underline = true,         -- underline problematic code
  update_in_insert = false, -- show only in normal mode (optional)
})


local pok, platformio = pcall(require, 'platformio')
if pok then
  platformio.setup({
    lsp = 'ccls',
    menu_key = '<leader>\\', -- replace this menu key  to your convenience
  })
end

vim.lsp.config('ccls', {
  on_attach = on_attach,
  init_options = {
    compilationDatabaseDirectory = ".",
    index = {
      threads = 0,
    },
    clang = {
      excludeArgs = { "-frounding-math" },
    },
    cache = {
      directory = vim.fn.expand("~/.cache/ccls"),
    },
  },
  root_dir = root_pattern({'.ccls', 'compile_commands.json', '.git'}),
})
