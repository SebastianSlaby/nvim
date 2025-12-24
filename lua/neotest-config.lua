-- neotest-config.lua
local neotest = require "neotest"

neotest.setup {
  adapters = {
    require "neotest-golang" {
      go_test_args = { "-v", "-race", "-count=1" },
      dap_go_enabled = false,
      log_level = vim.log.levels.DEBUG, -- Enable debug logging
      testify_enabled = true, -- Enable testify support for better diagnostics
    },
  },
  status = {
    enabled = true,
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
    open = "belowright split | resize 15",
  },
  summary = {
    enabled = true,
    expand_errors = true,
    follow = true,
    open = "belowright split | resize 15",
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
}

-- Keymaps for neotest
local opts = { noremap = true, silent = true }

-- Run the nearest test
vim.keymap.set("n", "<leader>tn", function()
  neotest.run.run()
end, { desc = "Neotest: Run nearest test" })

-- Run all tests in current file
vim.keymap.set("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand "%")
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
  neotest.output.open { enter = true, auto_close = true }
end, { desc = "Neotest: Toggle floating output" })

-- Jump to next failed test
vim.keymap.set("n", "]t", function()
  neotest.jump.next { status = "failed" }
end, { desc = "Neotest: Jump to next failed" })

-- Jump to previous failed test
vim.keymap.set("n", "[t", function()
  neotest.jump.prev { status = "failed" }
end, { desc = "Neotest: Jump to prev failed" })

-- Configure diagnostics for the neotest namespace to show inline errors
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    source = "if_many",
  },
  signs = true,
  underline = true,
}, vim.api.nvim_create_namespace("neotest"))

-- Debug command to check neotest diagnostics
vim.api.nvim_create_user_command("NeotestDiagDebug", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local file_path = vim.api.nvim_buf_get_name(bufnr)
  local ns_id = vim.api.nvim_create_namespace("neotest")

  print("=== Neotest Diagnostic Debug ===")
  print("Buffer:", bufnr, file_path)

  -- Check diagnostics
  local all_diags = vim.diagnostic.get(bufnr)
  local neotest_diags = vim.diagnostic.get(bufnr, { namespace = ns_id })
  print("Total diagnostics:", #all_diags)
  print("Neotest diagnostics:", #neotest_diags)

  for i, d in ipairs(neotest_diags) do
    print(string.format("  [%d] Line %d: %s", i, d.lnum + 1, d.message))
  end

  -- Check neotest results directly
  print("\n--- Neotest Results ---")
  local nt = require("neotest")

  -- Try to get results for this file
  local client = rawget(nt, "_client")
  if client then
    local adapters = client:get_adapters()
    for _, adapter_id in ipairs(adapters) do
      print("Adapter:", adapter_id)
      local results = client:get_results(adapter_id)
      for pos_id, result in pairs(results) do
        if pos_id:find(vim.fn.fnamemodify(file_path, ":t"), 1, true) then
          print("  Position:", pos_id)
          print("    Status:", result.status)
          if result.errors then
            print("    Errors:", #result.errors)
            for j, err in ipairs(result.errors) do
              print(string.format("      [%d] line=%s msg=%s",
                j,
                err.line ~= nil and tostring(err.line) or "nil",
                err.message or "(no message)"))
            end
          else
            print("    Errors: nil")
          end
        end
      end
    end
  else
    print("Could not access neotest client")
  end

  print("\nGlobal virtual_text:", vim.inspect(vim.diagnostic.config().virtual_text))
  print("\nLog file: ~/.local/state/nvim/neotest-golang.log")
end, {})
