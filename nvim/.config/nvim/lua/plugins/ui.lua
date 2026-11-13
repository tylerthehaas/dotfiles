-- UI: colorschemes, statusline, bufferline, dashboard, explorer, indent guides, winbar breadcrumbs
local icons = require("config.icons")

return {
  -- colorschemes (catppuccin-mocha is the default, as in your lvim config)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({})
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  { "folke/tokyonight.nvim", lazy = true },
  { "lunarvim/lunar.nvim", lazy = true },
  { "lunarvim/onedarker.nvim", lazy = true },
  {
    -- `:colorscheme cobalt2` (no longer forced at startup)
    "lalitmee/cobalt2.nvim",
    lazy = true,
    dependencies = { "tjdevries/colorbuddy.nvim" },
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },

  -- statusline (LunarVim "lvim" style approximation)
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    opts = function()
      local function lsp_names()
        local names = {}
        for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
          if c.name ~= "copilot" then table.insert(names, c.name) end
        end
        local ok, conform = pcall(require, "conform")
        if ok then
          for _, f in ipairs(conform.list_formatters(0)) do table.insert(names, f.name) end
        end
        if #names == 0 then return "LSP Inactive" end
        return "[" .. table.concat(vim.fn.uniq(names), ", ") .. "]"
      end
      return {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { { "branch", icon = icons.git.Branch } },
          lualine_c = {
            {
              "diff",
              symbols = { added = icons.git.LineAdded .. " ", modified = icons.git.LineModified .. " ", removed = icons.git.LineRemoved .. " " },
            },
          },
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = icons.diagnostics.Error .. " ", warn = icons.diagnostics.Warning .. " ", info = icons.diagnostics.Information .. " ", hint = icons.diagnostics.Hint .. " " },
            },
            lsp_names,
            function() return "󰌒 " .. vim.bo.shiftwidth end,
            "filetype",
          },
          lualine_y = { "location" },
          lualine_z = { "progress" },
        },
        extensions = { "nvim-tree", "toggleterm", "lazy", "quickfix" },
      }
    end,
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "User FileOpened",
    opts = {
      options = {
        close_command = function(bufnr) _G.BufferKill(bufnr, false) end,
        right_mouse_command = "vert sbuffer %d",
        left_mouse_command = "buffer %d",
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        offsets = {
          { filetype = "undotree", text = "Undotree", highlight = "PanelHeading", padding = 1 },
          { filetype = "NvimTree", text = "Explorer", highlight = "PanelHeading", padding = 1 },
          { filetype = "DiffviewFiles", text = "Diff View", highlight = "PanelHeading", padding = 1 },
          { filetype = "lazy", text = "Lazy", highlight = "PanelHeading", padding = 1 },
        },
        separator_style = "thin",
        always_show_bufferline = false,
        show_close_icon = false,
      },
    },
  },

  -- dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "                                   _           ",
        "  ____  ___  ____ _   __(_)___ ___ ",
        " / __ \\/ _ \\/ __ \\ | / / / __ `__ \\",
        "/ / / /  __/ /_/ / |/ / / / / / / /",
        "/_/ /_/\\___/\\____/|___/_/_/ /_/ /_/ ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", icons.ui.FindFile .. "  Find File", "<CMD>Telescope find_files<CR>"),
        dashboard.button("n", icons.ui.NewFile .. "  New File", "<CMD>ene!<CR>"),
        dashboard.button("p", icons.ui.Project .. "  Projects ", "<CMD>Telescope projects<CR>"),
        dashboard.button("r", icons.ui.History .. "  Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("t", icons.ui.FindText .. "  Find Text", "<CMD>Telescope live_grep<CR>"),
        dashboard.button("c", icons.ui.Gear .. "  Configuration", "<CMD>edit " .. vim.fn.stdpath("config") .. "/init.lua<CR>"),
        dashboard.button("q", icons.ui.Close .. "  Quit", "<CMD>quit<CR>"),
      }
      require("alpha").setup(dashboard.config)
    end,
  },

  -- file explorer (left side, git icons hidden — from your lvim config)
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = false,
      hijack_directories = { enable = false },
      update_focused_file = { enable = true, update_root = true },
      view = { side = "left", width = 30 },
      renderer = {
        group_empty = false,
        root_folder_label = ":t",
        indent_markers = { enable = false },
        icons = { show = { git = false } },
      },
      diagnostics = { enable = true, show_on_dirs = false },
      filters = { dotfiles = false, custom = { "node_modules", "\\.cache" } },
      git = { enable = true, ignore = false, timeout = 200 },
      actions = { open_file = { resize_window = false } },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        api.config.mappings.default_on_attach(bufnr)
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        local function node_dir()
          local node = api.tree.get_node_under_cursor()
          return node and (node.type == "directory" and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h"))
        end
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("CD"))
        vim.keymap.set("n", "gtg", function() require("telescope.builtin").live_grep({ search_dirs = { node_dir() } }) end, opts("Telescope Live Grep"))
        vim.keymap.set("n", "gtf", function() require("telescope.builtin").find_files({ cwd = node_dir() }) end, opts("Telescope Find File"))
      end,
    },
  },

  -- directory buffers (`nvim .`) open in lir, like LunarVim
  {
    "tamago324/lir.nvim",
    lazy = false,
    config = function()
      local actions = require("lir.actions")
      local mark_actions = require("lir.mark.actions")
      local clipboard_actions = require("lir.clipboard.actions")
      require("lir").setup({
        show_hidden_files = false,
        ignore = {},
        devicons = { enable = true, highlight_dirname = true },
        mappings = {
          ["l"] = actions.edit,
          ["<CR>"] = actions.edit,
          ["<C-s>"] = actions.split,
          ["v"] = actions.vsplit,
          ["<C-t>"] = actions.tabedit,
          ["h"] = actions.up,
          ["q"] = actions.quit,
          ["A"] = actions.mkdir,
          ["a"] = actions.newfile,
          ["r"] = actions.rename,
          ["@"] = actions.cd,
          ["Y"] = actions.yank_path,
          ["i"] = actions.toggle_show_hidden,
          ["d"] = actions.delete,
          ["J"] = function()
            mark_actions.toggle_mark()
            vim.cmd("normal! j")
          end,
          ["c"] = clipboard_actions.copy,
          ["x"] = clipboard_actions.cut,
          ["p"] = clipboard_actions.paste,
        },
        float = { winblend = 0, curdir_window = { enable = false, highlight_dirname = true } },
        hide_cursor = false,
      })
    end,
  },

  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "User FileOpened",
    opts = {
      indent = { char = icons.ui.LineLeft },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = {
        filetypes = { "help", "startify", "dashboard", "lazy", "neogitstatus", "NvimTree", "Trouble", "text", "alpha", "lir", "mason", "toggleterm" },
        buftypes = { "terminal", "nofile" },
      },
    },
  },

  -- breadcrumbs in the winbar (LunarVim's breadcrumbs.active)
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = { highlight = true, separator = " " .. icons.ui.ChevronRight .. " ", depth_limit = 0, lazy_update_context = false },
    init = function()
      local excluded = {
        "help", "startify", "dashboard", "lazy", "neo-tree", "neogitstatus", "NvimTree", "Trouble", "alpha",
        "lir", "Outline", "spectre_panel", "toggleterm", "DressingSelect", "Jaq", "harpoon", "dap-repl",
        "dap-terminal", "dapui_console", "dapui_hover", "lab", "notify", "noice", "neotest-summary", "",
      }
      vim.api.nvim_create_autocmd({ "CursorHoldI", "CursorHold", "BufWinEnter", "BufFilePost", "InsertEnter", "BufWritePost", "TabClosed" }, {
        group = vim.api.nvim_create_augroup("_winbar", { clear = true }),
        callback = function()
          if vim.tbl_contains(excluded, vim.bo.filetype) or vim.bo.buftype ~= "" or vim.api.nvim_win_get_config(0).zindex then
            return
          end
          local name = vim.fn.expand("%:t")
          if name == "" then return end
          local icon, hl = require("nvim-web-devicons").get_icon(name, vim.fn.expand("%:e"), { default = true })
          local value = " %#" .. hl .. "#" .. icon .. "%* %#Winbar#" .. name .. "%*"
          local ok, navic = pcall(require, "nvim-navic")
          if ok and navic.is_available() then
            local loc = navic.get_location()
            if loc ~= "" then value = value .. " " .. icons.ui.ChevronRight .. " " .. loc end
          end
          if vim.bo.modified then value = value .. " %#LspCodeLens#●%*" end
          pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
        end,
      })
    end,
  },
}
