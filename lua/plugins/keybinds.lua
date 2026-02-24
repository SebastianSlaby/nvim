local function is_neotree_focused() return vim.bo.filetype == "neo-tree" end

vim.keymap.set("n", "<Tab>", function()
  if is_neotree_focused() then
    -- Switch to next source (File → Buffers → Git → File...)
    vim.api.nvim_feedkeys(">", "n", false)
  else
    vim.cmd "bnext"
  end
end, { noremap = true, silent = true })

vim.keymap.set("n", "<S-Tab>", function()
  if is_neotree_focused() then
    -- Switch to previous source (File → Git → Buffers → File...)
    vim.api.nvim_feedkeys("<", "n", false)
  else
    vim.cmd "bprevious"
  end
end, { noremap = true, silent = true })

return {}
