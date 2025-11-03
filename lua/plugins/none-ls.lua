return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.rustfmt,
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.rs",
      callback = function()
        vim.lsp.buf.format({
          async = false,
          filter = function(client) return client.name == "rust_analyzer" end,
        })
      end,
    })

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
