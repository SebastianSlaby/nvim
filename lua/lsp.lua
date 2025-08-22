-- lsp.lua
local lspconfig = require("lspconfig")
--lspconfig.gopls.setup({})
lspconfig.jsonls.setup({})


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
}

local nvim_lsp = require('lspconfig')
local configs = require('lspconfig.configs')

if not configs.jinja_lsp then
    configs.jinja_lsp = {
        default_config = {
            name = "jinja-lsp",
            cmd = { 'jinja-lsp' },
            filetypes = { 'jinja' },
            root_dir = function(fname)
                return '.' -- or use a more sophisticated root dir detection
            end,
            init_options = {
                templates = './templates', -- your templates folder
                backend = { './src' }, -- backend directory if applicable
                lang = "rust"      -- or "python" depending on your backend
            },
        },
    }
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

nvim_lsp.jinja_lsp.setup {
    capabilities = capabilities,
}

--local on_attach = function(client, bufnr)
--  local opts = { noremap=true, silent=true, buffer=bufnr }
--  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--end


--require'nvim-treesitter.configs'.setup {
--  highlight = { enable = true },
--  ensure_installed = { "go", "lua", "python", "bash", "json", "yaml" }, -- Add your languages here
--}

require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "c", "go", "python", "bash", "json", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

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
    virtual_text = true,    -- show inline diagnostic text
    signs = true,           -- keep gutter signs W/H/etc.
    underline = true,       -- underline problematic code
    update_in_insert = false, -- show only in normal mode (optional)
})
