return {
  'tpope/vim-fugitive',
  config = function ()
    vim.keymap.set('n', '<leader>gh', ':diffget //3<CR>', {desc = "Git Get Diff on Right"})
    vim.keymap.set('n', '<leader>gf', ':diffget //2<CR>', {desc = "Git Get Diff on Left"})
    vim.keymap.set('n', '<leader>gs', ':G<CR>', {desc = "[G]it [S]tatus"})
    vim.keymap.set('n', '<leader>gc', ':G commit -m ""<left>', {desc = "[G]it [C]ommit"})
    vim.keymap.set('n', '<leader>gu', ':G push<CR>', {desc = "[G]it P[u]sh"})
  end
}
