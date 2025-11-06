return {
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      use_diagnostic_signs = true,
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xw", "<cmd>Trouble workspace_diagnostics toggle<cr>", desc = "Workspace Diagnostics" },
      { "<leader>xd", "<cmd>Trouble document_diagnostics toggle<cr>", desc = "Document Diagnostics" },
    },
  },
  {
    "folke/lsp-colors.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup()
      vim.diagnostic.config({ virtual_text = false })
    end,
  },
}
