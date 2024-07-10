return {
  'ThePrimeagen/harpoon',
  config = function()
    vim.keymap.set({ 'n', 'v' }, '<leader>ma', function() require("harpoon.mark").add_file() end, { desc = "[M]arks [A]dd file" })
    vim.keymap.set({ 'n', 'v' }, '<leader>mm', function() require("harpoon.ui").toggle_quick_menu() end, { desc = "Open [M]arks [M]enu" })
    vim.keymap.set({ 'n', 'v' }, '<leader>mn', function() require("harpoon.ui").nav_next() end, { desc = "[M]arks [N]ext" })
    vim.keymap.set({ 'n', 'v' }, '<leader>mp', function() require("harpoon.ui").nav_prev() end, { desc = "[M]arks [P]revious" })

    vim.keymap.set({ 'n', 'v' }, '<leader>m1', function() require("harpoon.ui").nav_file(1) end, { desc = "[M]ark [F]ile 1" })
    vim.keymap.set({ 'n', 'v' }, '<leader>m2', function() require("harpoon.ui").nav_file(2) end, { desc = "[M]ark [F]ile 2" })
    vim.keymap.set({ 'n', 'v' }, '<leader>m3', function() require("harpoon.ui").nav_file(3) end, { desc = "[M]ark [F]ile 3" })
    vim.keymap.set({ 'n', 'v' }, '<leader>m4', function() require("harpoon.ui").nav_file(4) end, { desc = "[M]ark [F]ile 4" })
    vim.keymap.set({ 'n', 'v' }, '<leader>m5', function() require("harpoon.ui").nav_file(5) end, { desc = "[M]ark [F]ile 5" })
    vim.keymap.set({ 'n', 'v' }, '<leader>m6', function() require("harpoon.ui").nav_file(6) end, { desc = "[M]ark [F]ile 6" })
    vim.keymap.set({ 'n', 'v' }, '<leader>m7', function() require("harpoon.ui").nav_file(7) end, { desc = "[M]ark [F]ile 7" })
    vim.keymap.set({ 'n', 'v' }, '<leader>m8', function() require("harpoon.ui").nav_file(8) end, { desc = "[M]ark [F]ile 8" })
    vim.keymap.set({ 'n', 'v' }, '<leader>m9', function() require("harpoon.ui").nav_file(9) end, { desc = "[M]ark [F]ile 9" })
    vim.keymap.set({ 'n', 'v' }, '<leader>m0', function() require("harpoon.ui").nav_file(0) end, { desc = "[M]ark [F]ile 0" })
    require("harpoon").setup({
      menu = {
	  width = vim.api.nvim_win_get_width(0) - 30,
      }
    })

  end
}
