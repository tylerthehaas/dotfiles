-- AI plugins from your lvim config: avante (gemini), amp, windsurf/codeium
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    build = "make",
    opts = {
      provider = "gemini",
      providers = {
        gemini = {
          api_key_name = "GEMINI_API_KEY",
          model = "gemini-2.0-flash",
          timeout = 30000,
          extra_request_body = { temperature = 0, max_tokens = 8192 },
        },
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      { "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
      "echasnovski/mini.pick",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "sourcegraph/amp.nvim",
    branch = "main",
    lazy = false,
    opts = { auto_start = true, log_level = "info" },
  },
  {
    "Exafunction/windsurf.vim",
    -- only auto-load once authenticated (`:Codeium Auth`), otherwise it prints
    -- "No API key found" on every buffer
    event = vim.fn.filereadable(vim.fn.expand("~/.codeium/config.json")) == 1 and "BufEnter" or nil,
    cmd = "Codeium",
  },
}
