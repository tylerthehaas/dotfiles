local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
local code_actions = null_ls.builtins.code_actions

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup {
 on_attach = function(client, bufnr)
    -- if client.supports_method("textDocument/formatting") then
    --   vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    --   vim.api.nvim_create_autocmd("BufWritePre", {
    --     group = augroup,
    --     buffer = bufnr,
    --     callback = function()
    --       -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
    --       vim.lsp.buf.formatting_sync()
    --     end,
    --   })
    -- end
    if client.name == "sumneko_lua" then
      client.server_capabilities.document_formatting = false
    end
  end,
  debug = false,
  sources = {
    -- eslint
    formatting.eslint_d,
    diagnostics.eslint_d,
    code_actions.eslint_d,

    -- lua
    formatting.stylua,
    -- formatting.prettier.with { extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } },
    -- formatting.black.with { extra_args = { "--fast" } },
    -- formatting.yapf,
    -- diagnostics.flake8,
  },
}
