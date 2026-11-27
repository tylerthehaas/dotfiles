-- User commands (replacements for LunarVim's Lvim* commands)
local cmd = vim.api.nvim_create_user_command

-- :BufferKill — delete the current buffer without closing its window (LunarVim's <leader>c)
local function buf_kill(bufnr, force)
  bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
  if not force and vim.bo[bufnr].modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname(bufnr)), "&Yes\n&No\n&Cancel")
    if choice == 1 then
      vim.api.nvim_buf_call(bufnr, function() vim.cmd("w") end)
    elseif choice == 2 then
      force = true
    else
      return
    end
  end
  -- switch every window showing this buffer to another listed buffer first
  local listed = vim.tbl_filter(function(b) return vim.bo[b].buflisted and b ~= bufnr end, vim.api.nvim_list_bufs())
  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.api.nvim_win_call(win, function()
      if #listed > 0 then
        vim.cmd("bprevious")
        if vim.api.nvim_get_current_buf() == bufnr then
          vim.api.nvim_win_set_buf(win, listed[1])
        end
      else
        vim.cmd("enew")
      end
    end)
  end
  if vim.api.nvim_buf_is_valid(bufnr) then
    pcall(vim.api.nvim_buf_delete, bufnr, { force = force })
  end
end
_G.BufferKill = buf_kill
cmd("BufferKill", function() buf_kill(0) end, { desc = "Close current buffer" })

local function toggle_format()
  vim.g.format_on_save = not vim.g.format_on_save
  vim.notify("Format on save: " .. (vim.g.format_on_save and "enabled" or "disabled"))
end
cmd("FormatToggle", toggle_format, { desc = "Toggle format on save" })
cmd("LvimToggleFormatOnSave", toggle_format, { desc = "Toggle format on save (lvim alias)" })

cmd("LvimInfo", "checkhealth vim.lsp", { desc = "Show LSP / formatter info" })

-- from your lvim config
cmd("GoTestFunc", function() require("neotest").run.run() end, { desc = "Run nearest test" })
