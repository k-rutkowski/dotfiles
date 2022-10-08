local config = {

  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_reload = false, -- automatically reload and sync packer after a successful update
    auto_quit = false, -- automatically quit the current session after a successful update
  },

  colorscheme = "default_theme",
  --colorscheme = "solarized",

  options = {
    opt = {
      cmdheight = 1,
      relativenumber = true, -- sets vim.opt.relativenumber
      number = true, -- sets vim.opt.number
      spell = true, -- sets vim.opt.spell
      signcolumn = "yes", -- sets vim.opt.signcolumn to auto
      wrap = false, -- sets vim.opt.wrap
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
      cmp_enabled = true, -- enable completion at start
      autopairs_enabled = true, -- enable autopairs at start
      diagnostics_enabled = true, -- enable diagnostics at start
      status_diagnostics_enabled = true, -- enable diagnostics in statusline
      solarized_termtrans = 1,
      solarized_visibility = 'normal',
      solarized_statusline = 'normal',
      solarized_italics = 1,
    },
  },

  header = {
    " █████  ███████ ████████ ██████   ██████  ███    ██ ██    ██ ██ ███    ███",
    "██   ██ ██         ██    ██   ██ ██    ██ ████   ██ ██    ██ ██ ████  ████",
    "███████ ███████    ██    ██████  ██    ██ ██ ██  ██ ██    ██ ██ ██ ████ ██",
    "██   ██      ██    ██    ██   ██ ██    ██ ██  ██ ██  ██  ██  ██ ██  ██  ██",
    "██   ██ ███████    ██    ██   ██  ██████  ██   ████   ████   ██ ██      ██",
    " ",
  },

  default_theme = {
  },

  diagnostics = {
    virtual_text = false,
    underline = true,
  },

  lsp = {
    -- enable servers that you already have installed without mason
    servers = {
      "pyright",
      "rust_analyzer",
    },
    formatting = {
      format_on_save = true,
    },
    mappings = {
    },

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
      -- example for addings schemas to yamlls
      -- yamlls = { -- override table for require("lspconfig").yamlls.setup({...})
      --   settings = {
      --     yaml = {
      --       schemas = {
      --         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      --         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      --         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      --       },
      --     },
      --   },
      -- },
    },
  },

  mappings = {
    n = {
      -- ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
      -- ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
      -- ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
      -- ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
      ["\\"] = { ";", desc = "Colon replacement" },
      [";"] = { ":", desc = "Colon replacement" },
    },
    v = {
      ["\\"] = { ";", desc = "Colon replacement" },
      [";"] = { ":", desc = "Colon replacement" },
    },
    i = {
      ["jk"] = { "<esc>", desc = "My Escape" },
      ["JK"] = { "<esc>", desc = "My Escape" },
    },
    t = {
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
    },
  },

  plugins = {
    init = {
      ["max397574/better-escape.nvim"] = { disable = true },
      {
        "catppuccin/nvim",
        as = "catppuccin",
        config = function()
          require("catppuccin").setup {}
        end,
      },
      {
        "ishan9299/nvim-solarized-lua",
        as = "solarized",
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}

return config
