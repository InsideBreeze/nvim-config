local function setup()
	-- options
	vim.opt.tabstop = 2
	vim.opt.shiftwidth = 2
	vim.opt.relativenumber = true
	-- ! not working
	vim.opt.swapfile = false
	vim.g.mapleader = " "

	vim.o.signcolumn = "no"
	vim.o.background = "dark"
	-- keymaps
	vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>Oil --float<cr>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<leader>`", "<cmd>ToggleTerm direction=float<cr>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<S-l>", ":BufferLineCycleNext<cr>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<S-h>", ":BufferLineCyclePrev<cr>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<leader>c", ":bdelete<cr>", { noremap = true })
end

return {
	setup = setup,
}
