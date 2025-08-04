return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'saghen/blink.cmp',
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',

    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    'folke/neodev.nvim',
  },

  config = function()
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(_, bufnr)
      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })

      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>la', vim.lsp.buf.code_action, 'Action')
      nmap('<leader>lf', vim.lsp.buf.format, 'Format')
      nmap('<leader>lr', vim.lsp.buf.rename, 'Rename')

      nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
      nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
      nmap('gI', vim.lsp.buf.implementation, 'Goto Implementation')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type Definition')
      nmap('<leader>fs', require('telescope.builtin').lsp_document_symbols, 'Find Symbols in Document')
      nmap('<leader>fS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Find Symbols in Workspace')

      -- See `:help K` for why this keymap
      --nmap('K', vim.lsp.buf.hover, 'Hover Documentation', { unique = true })
      nmap('<leader>K', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace Add Folder')
      nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace Remove Folder')
      nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, 'Workspace List Folders')
    end

    -- Enable the following language servers
    local servers = {
      rust_analyzer = {},
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- sumneko_lua = {},

      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    }

    -- Setup neovim lua configuration
    require('neodev').setup()

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    --local capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    capabilities = require('lspconfig').lua_ls.setup { capabilities = capabilities }

    -- Ensure the servers above are installed
    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    mason_lspconfig.setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
        }
      end,
    }
  end
}
