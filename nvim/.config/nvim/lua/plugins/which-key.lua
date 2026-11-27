-- which-key + all <leader> mappings (ported 1:1 from LunarVim's which_key.mappings)
local cfg = vim.fn.stdpath("config")

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "classic",
    plugins = { marks = false, registers = false, spelling = { enabled = true, suggestions = 20 } },
    win = { border = "single" },
    disable = { ft = { "TelescopePrompt" } },
    spec = {
      -- top level
      { "<leader>;", "<cmd>Alpha<CR>", desc = "Dashboard" },
      { "<leader>w", "<cmd>w!<CR>", desc = "Save" },
      { "<leader>q", "<cmd>confirm q<CR>", desc = "Quit" },
      { "<leader>/", "gcc", desc = "Comment toggle current line", remap = true },
      { "<leader>/", "gc", desc = "Comment toggle linewise (visual)", mode = "v", remap = true },
      { "<leader>c", "<cmd>BufferKill<CR>", desc = "Close Buffer" },
      {
        "<leader>f",
        function()
          -- git_files inside a repo, find_files otherwise (LunarVim's find_project_files)
          local ok = pcall(require("telescope.builtin").git_files, { previewer = false, show_untracked = true })
          if not ok then require("telescope.builtin").find_files({ previewer = false }) end
        end,
        desc = "Find File",
      },
      { "<leader>h", "<cmd>nohlsearch<CR>", desc = "No Highlight" },
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer" },

      -- Buffers
      { "<leader>b", group = "Buffers" },
      { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump" },
      { "<leader>bf", "<cmd>Telescope buffers previewer=false<cr>", desc = "Find" },
      { "<leader>bb", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous" },
      { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next" },
      { "<leader>bW", "<cmd>noautocmd w<cr>", desc = "Save without formatting (noautocmd)" },
      { "<leader>be", "<cmd>BufferLinePickClose<cr>", desc = "Pick which buffer to close" },
      { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
      { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },
      { "<leader>bD", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by directory" },
      { "<leader>bL", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by language" },

      -- Debug
      { "<leader>d", group = "Debug" },
      { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>db", function() require("dap").step_back() end, desc = "Step Back" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run To Cursor" },
      { "<leader>dd", function() require("dap").disconnect() end, desc = "Disconnect" },
      { "<leader>dg", function() require("dap").session() end, desc = "Get Session" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>du", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle Repl" },
      { "<leader>ds", function() require("dap").continue() end, desc = "Start" },
      { "<leader>dq", function() require("dap").close() end, desc = "Quit" },
      { "<leader>dU", function() require("dapui").toggle({ reset = true }) end, desc = "Toggle UI" },

      -- Plugins
      { "<leader>p", group = "Plugins" },
      { "<leader>pi", "<cmd>Lazy install<cr>", desc = "Install" },
      { "<leader>ps", "<cmd>Lazy sync<cr>", desc = "Sync" },
      { "<leader>pS", "<cmd>Lazy clear<cr>", desc = "Status" },
      { "<leader>pc", "<cmd>Lazy clean<cr>", desc = "Clean" },
      { "<leader>pu", "<cmd>Lazy update<cr>", desc = "Update" },
      { "<leader>pp", "<cmd>Lazy profile<cr>", desc = "Profile" },
      { "<leader>pl", "<cmd>Lazy log<cr>", desc = "Log" },
      { "<leader>pd", "<cmd>Lazy debug<cr>", desc = "Debug" },

      -- Git
      { "<leader>g", group = "Git" },
      { "<leader>gg", function() require("config.terminal").lazygit_toggle() end, desc = "Lazygit" },
      { "<leader>gj", function() require("gitsigns").nav_hunk("next", { navigation_message = false }) end, desc = "Next Hunk" },
      { "<leader>gk", function() require("gitsigns").nav_hunk("prev", { navigation_message = false }) end, desc = "Prev Hunk" },
      { "<leader>gl", function() require("gitsigns").blame_line() end, desc = "Blame" },
      { "<leader>gL", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame Line (full)" },
      { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk" },
      { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "Reset Hunk" },
      { "<leader>gR", function() require("gitsigns").reset_buffer() end, desc = "Reset Buffer" },
      { "<leader>gs", function() require("gitsigns").stage_hunk() end, desc = "Stage Hunk" },
      { "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, desc = "Undo Stage Hunk" },
      { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
      { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "Checkout commit(for current file)" },
      { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Git Diff" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk", mode = "v" },
      { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk", mode = "v" },

      -- LSP
      { "<leader>l", group = "LSP", mode = { "n", "v" } },
      { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
      { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", desc = "Buffer Diagnostics" },
      { "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>lf", function() require("conform").format({ lsp_format = "fallback" }) end, desc = "Format" },
      { "<leader>li", "<cmd>checkhealth vim.lsp<cr>", desc = "Info" },
      { "<leader>lI", "<cmd>Mason<cr>", desc = "Mason Info" },
      { "<leader>lj", function() vim.diagnostic.jump({ count = 1, float = true }) end, desc = "Next Diagnostic" },
      { "<leader>lk", function() vim.diagnostic.jump({ count = -1, float = true }) end, desc = "Prev Diagnostic" },
      { "<leader>ll", vim.lsp.codelens.run, desc = "CodeLens Action" },
      { "<leader>lq", vim.diagnostic.setloclist, desc = "Quickfix" },
      { "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<leader>le", "<cmd>Telescope quickfix<cr>", desc = "Telescope Quickfix" },

      -- Config (was +LunarVim)
      { "<leader>L", group = "+Config" },
      { "<leader>Lc", "<cmd>edit " .. cfg .. "/init.lua<cr>", desc = "Edit init.lua" },
      { "<leader>Lf", function() require("telescope.builtin").find_files({ cwd = cfg, prompt_title = "Config files" }) end, desc = "Find config files" },
      { "<leader>Lg", function() require("telescope.builtin").live_grep({ cwd = cfg, prompt_title = "Grep config files" }) end, desc = "Grep config files" },
      { "<leader>Lk", "<cmd>Telescope keymaps<cr>", desc = "View keymappings" },
      { "<leader>Li", "<cmd>checkhealth vim.lsp<cr>", desc = "LSP / buffer info" },
      { "<leader>Ll", group = "+logs" },
      { "<leader>Lll", function() require("config.terminal").toggle_log_view(vim.lsp.log.get_filename()) end, desc = "view lsp log" },
      { "<leader>LlL", function() vim.cmd.edit(vim.lsp.log.get_filename()) end, desc = "Open the LSP logfile" },
      { "<leader>Lln", function() require("config.terminal").toggle_log_view(vim.fn.stdpath("log") .. "/nvim.log") end, desc = "view neovim log" },
      { "<leader>LlN", function() vim.cmd.edit(vim.fn.stdpath("log") .. "/nvim.log") end, desc = "Open the Neovim logfile" },
      { "<leader>Llm", "<cmd>MasonLog<cr>", desc = "Open the Mason log" },
      { "<leader>Lu", "<cmd>Lazy update<cr>", desc = "Update plugins" },

      -- Search
      { "<leader>s", group = "Search" },
      { "<leader>sb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
      { "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find File" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Find highlight groups" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
      { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>st", "<cmd>Telescope live_grep<cr>", desc = "Text" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sl", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
      { "<leader>sp", function() require("telescope.builtin").colorscheme({ enable_preview = true }) end, desc = "Colorscheme with Preview" },

      -- Treesitter
      { "<leader>T", group = "Treesitter" },
      { "<leader>Ti", "<cmd>TSConfigInfo<cr>", desc = "Info" },
    },
  },
}
