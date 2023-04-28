return {
  -- {
  --   "folke/which-key.nvim",
  --   lazy = true,
  --   config = function()
  --     vim.o.timeout = true
  --     vim.o.timeoutlen = 300
  --     require("which-key").setup()
  --   end,
  -- },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    --		event = "VeryLazy",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    -- or                              , branch = '0.1.1',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>.", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>b", builtin.buffers, {})
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    end,
  },
}
