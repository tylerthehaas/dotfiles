-- Global (non-leader) keymaps from LunarVim's defaults.
-- Leader mappings live in lua/plugins/which-key.lua; LSP buffer maps in lua/plugins/lsp.lua.
local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { noremap = true, silent = true }, opts or {}))
end

-- insert mode
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
map("i", "<A-Up>", "<C-\\><C-N><C-w>k")
map("i", "<A-Down>", "<C-\\><C-N><C-w>j")
map("i", "<A-Left>", "<C-\\><C-N><C-w>h")
map("i", "<A-Right>", "<C-\\><C-N><C-w>l")

-- normal mode (window nav <C-h/j/k/l> comes from vim-tmux-navigator)
map("n", "<C-Up>", ":resize -2<CR>")
map("n", "<C-Down>", ":resize +2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")
map("n", "<A-j>", ":m .+1<CR>==")
map("n", "<A-k>", ":m .-2<CR>==")
map("n", "]q", ":cnext<CR>")
map("n", "[q", ":cprev<CR>")
map("n", "<C-q>", function()
  if vim.tbl_isempty(vim.tbl_filter(function(w) return w.quickfix == 1 end, vim.fn.getwininfo())) then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end, { desc = "Toggle quickfix" })
if vim.fn.has("mac") == 1 then
  map("n", "<A-Up>", ":resize -2<CR>")
  map("n", "<A-Down>", ":resize +2<CR>")
  map("n", "<A-Left>", ":vertical resize -2<CR>")
  map("n", "<A-Right>", ":vertical resize +2<CR>")
end

-- terminal mode
map("t", "<C-h>", "<C-\\><C-N><C-w>h")
map("t", "<C-j>", "<C-\\><C-N><C-w>j")
map("t", "<C-k>", "<C-\\><C-N><C-w>k")
map("t", "<C-l>", "<C-\\><C-N><C-w>l")

-- visual mode
map("v", "<", "<gv")
map("v", ">", ">gv")
map("x", "<A-j>", ":m '>+1<CR>gv-gv")
map("x", "<A-k>", ":m '<-2<CR>gv-gv")

-- command mode
map("c", "<C-j>", 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, silent = false })
map("c", "<C-k>", 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, silent = false })

-- hop.nvim motions (from your lvim config)
local function hop_char1(dir, offset)
  return function()
    local directions = require("hop.hint").HintDirection
    require("hop").hint_char1({ direction = directions[dir], current_line_only = false, hint_offset = offset })
  end
end
vim.keymap.set("", "f", hop_char1("AFTER_CURSOR"), { remap = true })
vim.keymap.set("", "F", hop_char1("BEFORE_CURSOR"), { remap = true })
vim.keymap.set("", "t", hop_char1("AFTER_CURSOR", -1), { remap = true })
vim.keymap.set("", "T", hop_char1("BEFORE_CURSOR", 1), { remap = true })
