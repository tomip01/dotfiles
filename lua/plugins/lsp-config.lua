return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local function setup(server, opts)
        opts = opts or {}
        opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, capabilities)
        vim.lsp.config(server, opts)
        vim.lsp.enable(server)
      end

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer", "elixirls", "solidity_ls" },
        automatic_enable = { exclude = { "rust_analyzer", "solc" } },
      })

      setup("elixirls", {
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/elixir-ls" },
      })

      setup("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      setup("solidity_ls", {
        cmd_env = {
          PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH,
        },
      })

      setup("rust_analyzer", {
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer" },
        on_attach = function(client, bufnr)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc and ("Rust: " .. desc) or nil })
          end

          map("<leader>rh", vim.lsp.buf.hover, "Hover")
          map("<leader>ra", vim.lsp.buf.code_action, "Code Action")

          local function set_inlay(enable)
            if not client.server_capabilities.inlayHintProvider then
              return
            end
            local inlay = vim.lsp.inlay_hint
            if type(inlay) == "table" and type(inlay.enable) == "function" then
              pcall(inlay.enable, enable, { bufnr = bufnr })
            elseif type(inlay) == "function" then
              pcall(inlay, bufnr, enable)
            elseif vim.lsp.buf and type(vim.lsp.buf.inlay_hint) == "function" then
              pcall(vim.lsp.buf.inlay_hint, bufnr, enable)
            end
          end

          if client.server_capabilities.inlayHintProvider then
            set_inlay(true)
            map("<leader>ri", function()
              local inlay = vim.lsp.inlay_hint
              local enabled = nil
              if type(inlay) == "table" and type(inlay.is_enabled) == "function" then
                enabled = inlay.is_enabled { bufnr = bufnr }
              end
              set_inlay(not enabled)
            end, "Toggle Inlay Hints")
          end
        end,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = true,
            check = {
              command = "clippy",
            },
            inlayHints = {
              bindingModeHints = { enable = true },
              chainingHints = { enable = true },
              lifetimeElisionHints = {
                enable = "always",
                useParameterNames = true,
              },
              parameterHints = { enable = true },
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "solc" then
            vim.schedule(function()
              vim.lsp.stop_client(client.id)
            end)
          end
        end,
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
      })
    end,
  },
}
