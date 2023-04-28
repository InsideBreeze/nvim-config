vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.relativenumber = true
-- ! not working
vim.opt.swapfile = false
vim.g.mapleader = " "

-- keymap now
vim.keymap.set("n", "<leader>e", "<cmd>Oil --float .<cr>")
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>")

-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
