return {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
			vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
			-- Extra pickers
			vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
			vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
			vim.keymap.set('n', '<leader>fr', builtin.resume, {})
			vim.keymap.set('n', '<leader>ld', builtin.diagnostics, {})
		end
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			telescope.setup({
				defaults = {
					path_display = { "smart" },
					dynamic_preview_title = true,
					mappings = {
						i = {
							["<C-q>"] = actions.smart_send_to_qflist,
							["<C-s>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,
						},
					},
				},
				pickers = {
					find_files = { hidden = true },
					buffers = { sort_lastused = true, ignore_current_buffer = true },
					live_grep = {
						additional_args = function(_)
							return { "--hidden" }
						end,
					},
				},
				extensions = {
					["ui-select"] = require("telescope.themes").get_dropdown({}),
					fzf = {
						fuzzy = true,
						case_mode = "smart_case",
					},
				},
			})
			telescope.load_extension("ui-select")
			pcall(telescope.load_extension, "fzf")
		end
	}
}
