--This file contains basic Vim configs and options, and sets up Lazy.nvim.
-- All plugins are defined in, and managed in their own files

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- [[ Setting options ]]

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.errorbells = false

-- configure tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.paste = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = true

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = {
	tab = "| ",
	trail = "·",
	nbsp = "␣",
}

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- [[ Basic Keymaps ]]

-- remap 'jj' to Esc
-- vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true, nowait = true })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>V", "ggVG", { desc = "Select All" })
vim.keymap.set("n", "<leader>v", ":vsp<CR>", { desc = "Vertical Split" })

vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("v", "<C-r>", '"hy:%s/<C-r>h/<C-r>h/g<left><left>', { desc = "Find/Replace Selected Text" })
-- vim.keymap.set("n", ";", ":", { desc = "CMD enter command mode" })

-- resizing windows
vim.keymap.set({ "n", "v" }, "<C-Left>", ":vertical resize +3<CR>", { desc = "Move Window Border Left" })
vim.keymap.set({ "n", "v" }, "<C-Right>", ":vertical resize -3<CR>", { desc = "Move Window Border Right" })
vim.keymap.set({ "n", "v" }, "<C-Up>", ": resize -3<CR>", { desc = "Move Window Border Up" })
vim.keymap.set({ "n", "v" }, "<C-Down>", ": resize +3<CR>", { desc = "Move Window Border Down" })
vim.cmd([[let g:tmux_naviagtor_preserve_zoom = 1]]) -- disable moving to other tmux windows when current window is zoomed

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<Tab>", ":bnext\n", { desc = "Move to the next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious\n", { desc = "Move to the last buffer" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)
-- Add your plugins to `lua/custom/plugins/*.lua` to get going.
--    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
require("lazy").setup("plugins")
