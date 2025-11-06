return {
	"petertriho/nvim-scrollbar",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"lewis6991/gitsigns.nvim",
	},
	config = function()
		local scrollbar = require("scrollbar")
		scrollbar.setup({
			show = true,
			handlers = {
				diagnostic = true,
				git = true,
				search = true,
			},
		})
		require("scrollbar.handlers.diagnostic").setup()
		pcall(require, "scrollbar.handlers.gitsigns")
		pcall(require, "scrollbar.handlers.search")
	end,
}
