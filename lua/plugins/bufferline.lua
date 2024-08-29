return {
	"akinsho/bufferline.nvim",
	-- version = "v3.*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				mode = "tabs", -- set to "tabs" to only show tabpages instead
				numbers = "ordinal",
				indicator = {
					style = "underline",
				},
				separator_style = "slant",
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,
			},
		})
	end,
}
