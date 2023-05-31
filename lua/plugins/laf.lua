return {
	{
		"stevearc/oil.nvim",
		event = "VeryLazy",
		config = function()
			require("oil").setup()
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		event = "User FileOpened",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup()
		end,
	},
	{
		"neanias/everforest-nvim",
		lazy = false,
		priority = 1000,
		version = false,
		config = function()
			vim.cmd([[colorscheme everforest]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		config = function()
			require("lualine").setup({
				options = {
					theme = "onelight",
				},
			})
		end,
	},
}
