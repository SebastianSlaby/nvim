return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      -- toggle if diagnostics are enabled on startup
      diagnostics = {
        virtual_text = true,
        virtual_lines = false, -- disable one option on startup
      },
    },
    -- Configuration passed to `vim.diagnostic.config()`
    -- All available options can be found with `:h vim.diagnostic.Opts`
    diagnostics = {
      virtual_text = true,
      virtual_lines = false, -- Neovim v0.11+ only
      update_in_insert = false,
      underline = true,
      severity_sort = true,
    },
  },
}
