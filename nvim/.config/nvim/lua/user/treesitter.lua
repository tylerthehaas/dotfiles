local configs = require'nvim-treesitter.configs'
configs.setup {
  ensure_installed = "all", -- one of "all" or a list of languages (https://github.com/nvim-treesitter/nvim-treesitter#supported-languages)
  sync_install = false,
  ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
  autopairs = {
    enable = true
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}
