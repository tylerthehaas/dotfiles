-- LSP (native vim.lsp.config / vim.lsp.enable), mason, formatting (conform), linting (nvim-lint)

-- LunarVim auto-installed one server per filetype on first open. Same idea here:
-- filetype -> preferred lspconfig server name.
local auto_servers = {
  javascript = "ts_ls", javascriptreact = "ts_ls", typescript = "ts_ls", typescriptreact = "ts_ls",
  ["javascript.jsx"] = "ts_ls", ["typescript.tsx"] = "ts_ls",
  lua = "lua_ls",
  json = "jsonls", jsonc = "jsonls",
  yaml = "yamlls",
  sh = "bashls", bash = "bashls",
  python = "pyright",
  go = "gopls", gomod = "gopls",
  css = "cssls", scss = "cssls", less = "cssls",
  html = "html",
  rust = "rust_analyzer",
  c = "clangd", cpp = "clangd",
  dockerfile = "dockerls",
  markdown = "marksman",
  toml = "taplo",
  terraform = "terraformls",
}

local function lsp_on_attach(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then return end
  local bufnr = args.buf
  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc, nowait = true, silent = true })
  end
  -- LunarVim's lvim.lsp.buffer_mappings
  map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Show hover")
  map("gd", vim.lsp.buf.definition, "Goto definition")
  map("gD", vim.lsp.buf.declaration, "Goto Declaration")
  map("gr", vim.lsp.buf.references, "Goto references")
  map("gI", vim.lsp.buf.implementation, "Goto Implementation")
  map("gs", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "show signature help")
  map("gl", function()
    local float = vim.diagnostic.config().float
    if float then
      local config = type(float) == "table" and vim.deepcopy(float) or {}
      config.scope = "line"
      vim.diagnostic.open_float(config)
    end
  end, "Show line diagnostics")

  if client:supports_method("textDocument/documentSymbol") then
    require("nvim-navic").attach(client, bufnr)
  end
  if client:supports_method("textDocument/codeLens") then
    vim.lsp.codelens.enable(true, { bufnr = bufnr })
  end
end

return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" },
    opts = { ui = { border = "rounded", width = 0.8, height = 0.9 } },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "User FileOpened", "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "b0o/schemastore.nvim",
      "SmiteshP/nvim-navic",
    },
    config = function()
      require("mason").setup({ ui = { border = "rounded", width = 0.8, height = 0.9 } })

      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- tsserver -> ts_ls, with the preferences from your lvim config + lsp-settings/tsserver.json
      vim.lsp.config("ts_ls", {
        init_options = { preferences = { disableSuggestions = true } },
        settings = { typescript = { preferences = { disableSuggestions = true } } },
      })
      vim.lsp.config("jsonls", {
        settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } },
      })
      vim.lsp.config("yamlls", {
        settings = { yaml = { schemaStore = { enable = false, url = "" }, schemas = require("schemastore").yaml.schemas() } },
      })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            telemetry = { enable = false },
            workspace = { checkThirdParty = false },
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- enables every mason-installed server automatically
      require("mason-lspconfig").setup({ ensure_installed = {}, automatic_enable = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = lsp_on_attach,
      })

      -- auto-install the preferred server for a filetype the first time it's opened
      local registry = require("mason-registry")
      local mapping = require("mason-lspconfig").get_mappings().lspconfig_to_package
      local requested = {}
      local function ensure_server(ft)
        local server = auto_servers[ft]
        local pkg_name = server and mapping[server]
        if not pkg_name or requested[pkg_name] then return end
        requested[pkg_name] = true
        registry.refresh(function()
          local ok, pkg = pcall(registry.get_package, pkg_name)
          if not ok or pkg:is_installed() then return end
          vim.notify(("Installation in progress for [%s]"):format(server))
          pkg:install():once("closed", vim.schedule_wrap(function()
            if pkg:is_installed() then
              vim.notify(("Installation complete for [%s]"):format(server))
              vim.lsp.enable(server)
            else
              vim.notify(("Installation failed for [%s], see :MasonLog"):format(server), vim.log.levels.WARN)
            end
          end))
        end)
      end
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_lsp_auto_install", { clear = true }),
        callback = function(args) ensure_server(vim.bo[args.buf].filetype) end,
      })
      ensure_server(vim.bo.filetype)
    end,
  },
  { "mason-org/mason-lspconfig.nvim", lazy = true },
  { "b0o/schemastore.nvim", lazy = true },
  { "folke/lazydev.nvim", ft = "lua", opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } } },

  -- formatting (replaces null-ls formatters: black, prettier --print-width 100)
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    lazy = true,
    opts = {
      formatters_by_ft = {
        python = { "black" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
      },
      formatters = {
        prettier = { prepend_args = { "--print-width", "100" } },
      },
      default_format_opts = { lsp_format = "fallback" },
      notify_no_formatters = false,
    },
  },

  -- linting (replaces null-ls eslint diagnostics); only runs when eslint is installed
  {
    "mfussenegger/nvim-lint",
    event = "User FileOpened",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint" },
        javascriptreact = { "eslint" },
        typescript = { "eslint" },
        typescriptreact = { "eslint" },
      }
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
        callback = function(args)
          local names = lint.linters_by_ft[vim.bo[args.buf].filetype] or {}
          local runnable = vim.tbl_filter(function(name)
            local linter = lint.linters[name]
            local cmd = type(linter) == "table" and linter.cmd or name
            if type(cmd) == "function" then cmd = cmd() end
            return vim.fn.executable(cmd) == 1
          end, names)
          if #runnable > 0 then lint.try_lint(runnable) end
        end,
      })
    end,
  },
}
