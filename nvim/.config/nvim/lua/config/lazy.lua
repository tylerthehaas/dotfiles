-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out } }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- "User FileOpened": fired once on the first real file buffer (LunarVim's lazy-load event)
vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("_file_opened", { clear = true }),
  nested = true,
  callback = function(args)
    local buftype = vim.bo[args.buf].buftype
    if not (vim.fn.expand("%") == "" or buftype == "nofile") then
      vim.api.nvim_del_augroup_by_name("_file_opened")
      vim.api.nvim_exec_autocmds("User", { pattern = "FileOpened" })
    end
  end,
})

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "catppuccin-mocha", "habamax" } },
  change_detection = { notify = false },
  ui = { border = "rounded" },
  rocks = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin", "netrwPlugin" },
    },
  },
})
