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

require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "go", "python", "bash", "json", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "terraform", "hcl" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
  --
  --
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

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
