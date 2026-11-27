-- toggleterm helpers (LunarVim's lvim.core.terminal)
local M = {}

M.opts = {
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = false,
  direction = "float",
  close_on_exit = true,
  auto_scroll = true,
  float_opts = { border = "curved", winblend = 0, highlights = { border = "Normal", background = "Normal" } },
  winbar = { enabled = false },
}

-- { cmd, keymap, label, direction, size }
M.execs = {
  { nil, "<M-1>", "Horizontal Terminal", "horizontal", 0.3 },
  { nil, "<M-2>", "Vertical Terminal", "vertical", 0.4 },
  { nil, "<M-3>", "Float Terminal", "float", nil },
}

local function dynamic_size(direction, size)
  size = size or M.opts.size
  if direction ~= "float" and tostring(size):find(".", 1, true) then
    size = math.min(size, 1.0)
    local win = vim.api.nvim_get_current_win()
    local dim = direction == "horizontal" and vim.api.nvim_win_get_height(win) or vim.api.nvim_win_get_width(win)
    return math.floor(dim * size)
  end
  return size
end

function M.setup_execs()
  for i, exec in ipairs(M.execs) do
    local cmd = exec[1] or vim.o.shell
    local direction = exec[4] or M.opts.direction
    if vim.fn.executable(cmd:match("(%S+)")) == 1 then
      vim.keymap.set({ "n", "t" }, exec[2], function()
        local Terminal = require("toggleterm.terminal").Terminal
        local term = Terminal:new({ cmd = cmd, count = i + 100, direction = direction })
        term:toggle(dynamic_size(direction, exec[5]), direction)
      end, { desc = exec[3], noremap = true, silent = true })
    end
  end
end

function M.lazygit_toggle()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = { border = "none", width = 100000, height = 100000, zindex = 200 },
    on_open = function(_) vim.cmd("startinsert!") end,
    on_close = function(_) end,
    count = 99,
  })
  lazygit:toggle()
end

function M.toggle_log_view(logfile)
  local viewer = vim.fn.executable("lnav") == 1 and "lnav" or "less +F"
  local Terminal = require("toggleterm.terminal").Terminal
  Terminal:new(vim.tbl_deep_extend("force", M.opts, {
    cmd = viewer .. " " .. logfile,
    open_mapping = "",
    direction = "float",
    float_opts = { border = "curved", width = 0.9, height = 0.9 },
  })):toggle()
end

return M
