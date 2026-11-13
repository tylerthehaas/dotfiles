-- Editor options (LunarVim defaults + your lvim config.lua overrides)
local icons = require("config.icons")
local opt = vim.opt

local undodir = vim.fn.stdpath("cache") .. "/undo"
vim.fn.mkdir(undodir, "p")

opt.backup = false
opt.clipboard = "unnamedplus"
opt.cmdheight = 1
opt.completeopt = { "menuone", "noselect" }
opt.conceallevel = 0
opt.fileencoding = "utf-8"
opt.foldmethod = "manual"
opt.hidden = true
opt.hlsearch = true
opt.ignorecase = true
opt.mouse = "a"
opt.pumheight = 10
opt.showmode = false
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.termguicolors = true
opt.timeoutlen = 1000
opt.title = true
opt.undodir = undodir
opt.undofile = true
opt.updatetime = 100
opt.writebackup = false
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.cursorline = true
opt.number = true
opt.relativenumber = true -- from your lvim config
opt.numberwidth = 4
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.showcmd = false
opt.ruler = false
opt.laststatus = 3
opt.spelllang:append("cjk")
opt.shortmess:append("c")
opt.shortmess:append("I")
opt.whichwrap:append("<,>,[,],h,l")

vim.g.raindbow_active = 1 -- kept from your lvim config

vim.filetype.add({
  extension = { tex = "tex", zir = "zir", cr = "crystal" },
  pattern = { ["[jt]sconfig.*.json"] = "jsonc" },
})

local S = vim.diagnostic.severity
vim.diagnostic.config({
  signs = {
    text = {
      [S.ERROR] = icons.diagnostics.Error,
      [S.WARN] = icons.diagnostics.Warning,
      [S.HINT] = icons.diagnostics.Hint,
      [S.INFO] = icons.diagnostics.Information,
    },
  },
  virtual_text = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
})

-- Format-on-save state (toggled with :FormatToggle / :LvimToggleFormatOnSave)
vim.g.format_on_save = true
