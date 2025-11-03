return {
	"ellisonleao/gruvbox.nvim",
	config = function()
		require("gruvbox").setup({
			contrast = "hard",
			transparent_mode = false,
			italic = { strings = false, comments = true },
			bold = true,
		})
		vim.o.background = "light"
		vim.cmd.colorscheme("gruvbox")
	end,
}
