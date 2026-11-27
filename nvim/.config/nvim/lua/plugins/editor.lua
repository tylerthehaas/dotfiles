-- Editing: telescope, treesitter, git, terminal, autopairs, comments, projects, misc
local icons = require("config.icons")

return {
  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local actions = require("telescope.actions")
      local send_qf = function(...)
        actions.smart_send_to_qflist(...)
        actions.open_qflist(...)
      end
      local telescope = require("telescope")
      telescope.setup({
        defaults = require("telescope.themes").get_dropdown({
          prompt_prefix = icons.ui.Telescope .. " ",
          selection_caret = icons.ui.Forward .. " ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename", "--line-number",
            "--column", "--smart-case", "--hidden", "--glob=!.git/",
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,
              ["<C-q>"] = send_qf,
              ["<CR>"] = actions.select_default,
            },
            n = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-q>"] = send_qf,
            },
          },
          path_display = { "smart" },
          winblend = 0,
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" },
        }),
        pickers = {
          find_files = { hidden = true },
          live_grep = { only_sort_text = true },
          grep_string = { only_sort_text = true },
          buffers = {
            initial_mode = "normal",
            mappings = { i = { ["<C-d>"] = actions.delete_buffer }, n = { ["dd"] = actions.delete_buffer } },
          },
          git_files = { hidden = true, show_untracked = true },
          colorscheme = { enable_preview = true },
        },
        extensions = {
          fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" },
        },
      })
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "projects")
    end,
  },

  -- project root detection + :Telescope projects
  {
    "ahmedkhalf/project.nvim",
    event = "VimEnter",
    config = function()
      require("project_nvim").setup({
        manual_mode = false,
        detection_methods = { "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pom.xml" },
        ignore_lsp = {},
        exclude_dirs = {},
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = "global",
        datapath = vim.fn.stdpath("data"),
      })
    end,
  },

  -- treesitter (master branch: the `main` rewrite needs the tree-sitter CLI)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = "User FileOpened",
    cmd = { "TSInstall", "TSUpdate", "TSUpdateSync", "TSInstallInfo", "TSConfigInfo" },
    init = function()
      -- nvim 0.12 dropped `all = false` for query predicates/directives: captures are always
      -- node *lists* now. nvim-treesitter master still registers handlers expecting a single
      -- node (crashes markdown code fences: "treesitter.lua: attempt to call method 'range'").
      -- Adapt those handlers so match[id] yields the last captured node, as before.
      local q = vim.treesitter.query
      for _, fname in ipairs({ "add_directive", "add_predicate" }) do
        local orig = q[fname]
        q[fname] = function(name, handler, opts)
          if type(opts) == "table" and opts.all == false then
            local h = handler
            handler = function(match, ...)
              local single = setmetatable({}, {
                __index = function(_, k)
                  local v = match[k]
                  if type(v) == "table" then return v[#v] end
                  return v
                end,
              })
              return h(single, ...)
            end
          end
          return orig(name, handler, opts)
        end
      end
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "javascript", "json", "lua", "python", "typescript", "tsx",
          "css", "rust", "java", "yaml", "go", "markdown", "markdown_inline", "vim", "vimdoc", "query",
        },
        ignore_install = { "haskell" },
        auto_install = true,
        highlight = {
          enable = true,
          disable = function(_, buf)
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > 1024 * 1024
          end,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true, disable = { "yaml", "python" } },
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-context", event = "User FileOpened", opts = {} },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "User FileOpened",
    opts = { enable_autocmd = false },
    init = function()
      -- make native `gc` commenting use treesitter context (jsx/tsx etc.)
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        if option == "commentstring" then
          local ok, internal = pcall(require, "ts_context_commentstring.internal")
          if ok then return internal.calculate_commentstring() or get_option(filetype, option) end
        end
        return get_option(filetype, option)
      end
    end,
  },
  { "HiPhish/rainbow-delimiters.nvim", event = "User FileOpened" },

  -- git
  {
    "lewis6991/gitsigns.nvim",
    event = "User FileOpened",
    cmd = "Gitsigns",
    opts = {
      signs = {
        add = { text = icons.ui.BoldLineLeft },
        change = { text = icons.ui.BoldLineLeft },
        delete = { text = "󰐊" },
        topdelete = { text = "󰐊" },
        changedelete = { text = icons.ui.BoldLineLeft },
      },
      signcolumn = true,
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = { virt_text = true, virt_text_pos = "eol", delay = 1000 },
      update_debounce = 200,
      max_file_length = 40000,
      preview_config = { border = "rounded", style = "minimal", relative = "cursor", row = 0, col = 1 },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
    ft = { "fugitive" },
    dependencies = "tpope/vim-rhubarb",
  },

  -- terminal
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec", "ToggleTermToggleAll", "ToggleTermSendCurrentLine", "ToggleTermSendVisualLines", "ToggleTermSendVisualSelection" },
    keys = { [[<c-\>]], "<M-1>", "<M-2>", "<M-3>" },
    config = function()
      local term = require("config.terminal")
      require("toggleterm").setup(term.opts)
      term.setup_execs()
    end,
  },

  -- editing helpers
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        ts_config = { lua = { "string", "source" }, javascript = { "string", "template_string" }, java = false },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {},
      })
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done({ map_char = { tex = "" } }))
      end
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = "User FileOpened",
    config = function()
      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex" },
        delay = 120,
        filetypes_denylist = {
          "dirvish", "fugitive", "alpha", "NvimTree", "lazy", "neogitstatus", "Trouble", "lir", "Outline",
          "spectre_panel", "toggleterm", "DressingSelect", "TelescopePrompt",
        },
        under_cursor = true,
        large_file_cutoff = 10000,
      })
    end,
  },
  {
    "LunarVim/bigfile.nvim",
    event = { "FileReadPre", "BufReadPre", "User FileOpened" },
    opts = { filesize = 2, pattern = { "*" } },
  },
  {
    "smoka7/hop.nvim",
    version = "*",
    opts = {},
  },
  { "tpope/vim-surround", event = "User FileOpened", dependencies = { "tpope/vim-repeat" } },
  { "christoomey/vim-tmux-navigator", lazy = false },
  { "folke/todo-comments.nvim", event = "User FileOpened", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
}
