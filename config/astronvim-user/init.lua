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
      conceallevel = 2,
      foldenable = false,
      foldexpr = "nvim_treesitter#foldexpr()",
      foldmethod = "expr",

      linebreak = true,
      list = true,
      listchars = { tab = "│→", extends = "⟩", precedes = "⟨", trail = "·", nbsp = "␣" },
      shortmess = vim.opt.shortmess + { I = true },
      showbreak = "↪ ",
      wrap = true,
      cmdheight = 1,
      scrolloff = 3,
      --tabstop = 4,
      --shiftwidth = 4,
      relativenumber = true,
      number = true,
      spell = true,
      signcolumn = "yes",
    },
    g = {
      -- colorcolumn = 80,
      mapleader = " ",
      cmp_enabled = true,
      autopairs_enabled = true,
      diagnostics_enabled = true,
      status_diagnostics_enabled = true,
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
      ["\\"] = { ";", desc = "" },
      [";"] = { ":", desc = "" },
      ["go"] = { "o<esc>k" },
      ["gO"] = { "O<esc>j" },
      j = { "gj", desc = "Navigate down" },
      k = { "gk", desc = "Navigate down" },
      ["-"] = { "<C-x>", desc = "Decrement number" },
      ["="] = { "<C-a>", desc = "Increment number" },

      ["<a-h>"] = { function() require("smart-splits").move_cursor_left() end, desc = "Move to left split" },
      ["<a-j>"] = { function() require("smart-splits").move_cursor_down() end, desc = "Move to below split" },
      ["<a-k>"] = { function() require("smart-splits").move_cursor_up() end, desc = "Move to above split" },
      ["<a-l>"] = { function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" },
      ["|"] = { "<cmd>vsplit<cr>", desc = "Vertical split" },
      ["<a-\\>"] = { "<cmd>split<cr>", desc = "Horizontal split" },
      ["<up>"] = { function() require("smart-splits").resize_up(2) end, desc = "Resize split up" },
      ["<down>"] = { function() require("smart-splits").resize_down(2) end, desc = "Resize split down" },
      ["<left>"] = { function() require("smart-splits").resize_left(2) end, desc = "Resize split left" },
      ["<right>"] = { function() require("smart-splits").resize_right(2) end, desc = "Resize split right" },

      ["<leader>\\"] = { "<cmd>ToggleTerm direction=float<cr>", desc = "Show floating terminal" },
      ["<leader>|"] = { "<cmd>ToggleTerm direction=horizontal size=12<cr>", desc = "Show terminal at the bottom" },
    },
    v = {
      ["\\"] = { ";", desc = "" },
      [";"] = { ":", desc = "" },
      j = { "gj", desc = "Navigate down" },
      k = { "gk", desc = "Navigate down" },
      ["-"] = { "<c-x>", desc = "Decrement numbers" },
      ["="] = { "<c-a>", desc = "Increment numbers" },
      ["_"] = { "g<c-x>", desc = "Decrement numbers" },
      ["+"] = { "g<c-a>", desc = "Increment numbers" },
    },
    i = {
      ["jk"] = { "<esc>", desc = "My Escape" },
      ["JK"] = { "<esc>", desc = "My Escape" },
    },
    t = {
      -- ["<esc>"] = false,
      ["<a-n>"] = { "<c-\\><c-n>", desc = "Terminal normal mode" },
      ["<a-q>"] = { "<c-\\><c-n>:q<cr>", desc = "Terminal quit" },
      ["<a-h>"] = { "<c-\\><c-n><c-w>h", desc = "Terminal left window navigation" },
      ["<a-j>"] = { "<c-\\><c-n><c-w>j", desc = "Terminal down window navigation" },
      ["<a-k>"] = { "<c-\\><c-n><c-w>k", desc = "Terminal up window navigation" },
      ["<a-l>"] = { "<c-\\><c-n><c-w>l", desc = "Terminal right window navigation" },
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
