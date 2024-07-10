return {
  'ggandor/leap.nvim',
  config = function()
    -- require('leap').create_default_mappings()
    require('leap').opts.safe_labels = {}
    vim.keymap.set({'n', 'x', 'o'}, 'f',  '<Plug>(leap-forward)')
    vim.keymap.set({'n', 'x', 'o'}, 'F',  '<Plug>(leap-backward)')
    vim.keymap.set({'n', 'x', 'o'}, 'gf', '<Plug>(leap-from-window)')
  end
}
