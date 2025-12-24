-- neotest-config.lua
local neotest = require("neotest")

neotest.setup({
  adapters = {
    require("neotest-golang")({
      go_test_args = { "-v", "-race", "-count=1" },
      dap_go_enabled = false,
    }),
  },
  status = {
    virtual_text = true,
    signs = true,
  },
  diagnostic = {
    enabled = true,
    severity = vim.diagnostic.severity.ERROR,
  },
  icons = {
    passed = "✓",
    failed = "✗",
    running = "⟳",
    skipped = "⊘",
    unknown = "?",
  },
  output = {
    enabled = true,
    open_on_run = false,
  },
  output_panel = {
    enabled = true,
    open = "botright split | resize 15",
  },
  summary = {
    enabled = true,
    expand_errors = true,
    follow = true,
    open = "botright split | resize 15",
    mappings = {
      expand = { "<CR>", "<2-LeftMouse>" },
      expand_all = "e",
      jumpto = "i",
      output = "o",
      run = "r",
      short = "O",
      stop = "u",
    },
  },
})

-- Keymaps for neotest
local opts = { noremap = true, silent = true }

-- Run the nearest test
vim.keymap.set("n", "<leader>tn", function()
  neotest.run.run()
end, { desc = "Neotest: Run nearest test" })

-- Run all tests in current file
vim.keymap.set("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand("%"))
end, { desc = "Neotest: Run file tests" })

-- Run all tests in project
vim.keymap.set("n", "<leader>ta", function()
  neotest.run.run(vim.fn.getcwd())
end, { desc = "Neotest: Run all tests" })

-- Stop running tests
vim.keymap.set("n", "<leader>ts", function()
  neotest.run.stop()
end, { desc = "Neotest: Stop tests" })

-- Toggle test summary panel
vim.keymap.set("n", "<leader>tt", function()
  neotest.summary.toggle()
end, { desc = "Neotest: Toggle summary" })

-- Toggle test output at bottom
vim.keymap.set("n", "<leader>to", function()
  neotest.output_panel.toggle()
end, { desc = "Neotest: Toggle output" })

-- Show output panel
vim.keymap.set("n", "<leader>tp", function()
  neotest.output.open({ enter = true, auto_close = true })
end, { desc = "Neotest: Toggle floating output" })

-- Jump to next failed test
vim.keymap.set("n", "]t", function()
  neotest.jump.next({ status = "failed" })
end, { desc = "Neotest: Jump to next failed" })

-- Jump to previous failed test
vim.keymap.set("n", "[t", function()
  neotest.jump.prev({ status = "failed" })
end, { desc = "Neotest: Jump to prev failed" })
