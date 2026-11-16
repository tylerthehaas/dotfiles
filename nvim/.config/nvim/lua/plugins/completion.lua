-- Completion + snippets (LunarVim's nvim-cmp setup and mappings)
return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
          require("luasnip.loaders.from_lua").lazy_load()
          require("luasnip.loaders.from_snipmate").lazy_load()
        end,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local ConfirmBehavior = cmp.ConfirmBehavior
      local SelectBehavior = cmp.SelectBehavior

      local kind_icons = {
        Text = "󰉿", Method = "m", Function = "󰊕", Constructor = "", Field = "", Variable = "󰆧",
        Class = "󰌗", Interface = "", Module = "", Property = "", Unit = "", Value = "󰎠",
        Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘", File = "󰈙", Reference = "",
        Folder = "󰉋", EnumMember = "", Constant = "󰇽", Struct = "", Event = "", Operator = "󰆕",
        TypeParameter = "󰊄", Copilot = "",
      }
      local source_names = {
        nvim_lsp = "(LSP)", path = "(Path)", luasnip = "(Snippet)", buffer = "(Buffer)", lazydev = "(Lua)",
        avante_commands = "(Avante)", avante_mentions = "(Avante)",
      }

      cmp.setup({
        confirm_opts = { behavior = ConfirmBehavior.Replace, select = false },
        completion = { keyword_length = 1 },
        experimental = { ghost_text = false },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            item.kind = kind_icons[item.kind] or item.kind
            item.menu = source_names[entry.source.name]
            return item
          end,
        },
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
        sources = {
          { name = "lazydev", group_index = 0 },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip" },
          { name = "buffer" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = SelectBehavior.Select }), { "i" }),
          ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = SelectBehavior.Select }), { "i" }),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = ConfirmBehavior.Replace, select = false }),
            c = function(fallback)
              if cmp.visible() then
                cmp.confirm({ behavior = ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              local opts = { behavior = ConfirmBehavior.Replace, select = false }
              if vim.api.nvim_get_mode().mode:sub(1, 1) == "i" then
                opts.behavior = ConfirmBehavior.Insert -- prevent overwriting brackets
              end
              if cmp.confirm(opts) then return end
            end
            fallback()
          end),
        }),
      })
    end,
  },
}
