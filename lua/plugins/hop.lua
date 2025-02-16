return {
    'smoka7/hop.nvim',
    version = "*",
    opts = {
        keys = 'etovxqpdygfblzhckisuran'
    },
    config = function()
        require('hop').setup{}
	vim.keymap.set({ "n", "v" }, "<leader>j", ":HopChar1<CR>", { desc = "[J]ump to character" })
    end
}
