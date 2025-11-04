return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose" },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
    { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
  },
  config = function()
    require("diffview").setup({
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal", -- or "diff2_vertical"
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
        },
      },
      file_panel = {
        listing_style = "tree", -- or "list"
        win_config = { position = "left", width = 35 },
      },
    })
  end,
}
