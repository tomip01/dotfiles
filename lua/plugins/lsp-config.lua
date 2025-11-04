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
      local has_new = vim.lsp and vim.lsp.config and vim.lsp.enable
      local lspconfig = nil
      if not has_new then
        lspconfig = require("lspconfig")
      end

      local function setup(server, opts)
        opts = opts or {}
        opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, capabilities)
        if has_new then
          vim.lsp.config(server, opts)
          vim.lsp.enable(server)
        else
          lspconfig[server].setup(opts)
        end
      end

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer", "elixirls", "solidity_ls" },
        handlers = {
          function(server_name)
            if server_name == "rust_analyzer" or server_name == "solc" then
              return
            end
            setup(server_name, {})
          end,

          ["elixirls"] = function()
            setup("elixirls", {
              cmd = { vim.fn.stdpath("data") .. "/mason/bin/elixir-ls" },
            })
          end,

          ["lua_ls"] = function()
            setup("lua_ls", {
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                },
              },
            })
          end,

          ["rust_analyzer"] = function()
            setup("rust_analyzer", {
              cmd = { vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer" },
              on_attach = function(client, bufnr)
                local function map(lhs, rhs, desc)
                  vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc and ("Rust: " .. desc) or nil })
                end

                map("<leader>rh", vim.lsp.buf.hover, "Hover")
                map("<leader>ra", vim.lsp.buf.code_action, "Code Action")

                if client.server_capabilities.inlayHintProvider then
                  local inlay = vim.lsp.inlay_hint
                  if type(inlay) == "function" then
                    pcall(inlay, bufnr, true)
                  elseif type(inlay) == "table" and type(inlay.enable) == "function" then
                    pcall(inlay.enable, bufnr, true)
                  elseif vim.lsp.buf and type(vim.lsp.buf.inlay_hint) == "function" then
                    pcall(vim.lsp.buf.inlay_hint, bufnr, true)
                  end
                end
              end,
              settings = {
                ["rust-analyzer"] = {
                  checkOnSave = {
                    command = "clippy",
                  },
                },
              },
            })
          end,

          ["solidity_ls"] = function()
            setup("solidity_ls", {
              cmd_env = {
                PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH,
              },
            })
          end,

          ["solc"] = function() end,
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
