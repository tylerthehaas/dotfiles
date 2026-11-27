-- Native Neovim config, ported from the LunarVim setup (~/.config/lvim).
-- Layout:
--   lua/config/*   options, keymaps, autocmds, commands, lazy bootstrap
--   lua/plugins/*  lazy.nvim plugin specs (one file per area)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("config.commands")
