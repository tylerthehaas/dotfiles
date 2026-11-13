-- Autocommands (LunarVim defaults)
local au = vim.api.nvim_create_autocmd
local group = function(name) return vim.api.nvim_create_augroup(name, { clear = true }) end

au("TextYankPost", {
  group = group("_general_settings"),
  desc = "Highlight text on yank",
  callback = function() vim.hl.on_yank({ higroup = "Search", timeout = 100 }) end,
})

au("FileType", { group = group("_hide_dap_repl"), pattern = "dap-repl", command = "set nobuflisted" })

local ft = group("_filetype_settings")
au("FileType", {
  group = ft,
  pattern = "lua",
  desc = "fix gf functionality inside .lua files",
  callback = function()
    vim.opt_local.include = [[\v<((do|load)file|require|reload)[^''"]*[''"]\zs[^''"]+]]
    vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
    vim.opt_local.suffixesadd:prepend(".lua")
    vim.opt_local.suffixesadd:prepend("init.lua")
    for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
      vim.opt_local.path:append(path .. "/lua")
    end
  end,
})
au("FileType", { group = ft, pattern = "alpha", command = "set nobuflisted" })
au("FileType", {
  group = ft,
  pattern = "lir",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

au("FileType", {
  group = group("_buffer_mappings"),
  pattern = { "qf", "help", "man", "floaterm", "lspinfo", "lir", "checkhealth", "tsplayground", "DressingSelect", "Jaq" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, silent = true })
    vim.opt_local.buflisted = false
  end,
})

au("VimResized", { group = group("_auto_resize"), command = "tabdo wincmd =" })

-- Format on save (conform.nvim), toggled via vim.g.format_on_save
au("BufWritePre", {
  group = group("format_on_save"),
  callback = function(args)
    if vim.g.format_on_save then
      require("conform").format({ bufnr = args.buf, timeout_ms = 1000, lsp_format = "fallback" })
    end
  end,
})
