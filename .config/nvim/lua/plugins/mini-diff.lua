-- Enable this plugin mainly for the overlay feature.
-- Want to keep using gitsigns so don't enable this plugin in LazyVim extra
return {
	"echasnovski/mini.diff",
	event = "VeryLazy",
	opts = {
		options = {
			algorithm = "minimal",
		},
		-- Module mappings. Use `''` (empty string) to disable one.
    -- Use gitsigns
		mappings = {
			apply = "",
			reset = "",
			textobject = "",
			goto_first = "",
			goto_prev = "",
			goto_next = "",
			goto_last = "",
		},
	},
	keys = {
		{
			"<leader>go",
			function()
				require("mini.diff").toggle_overlay(0)
			end,
			desc = "Toggle Overlay",
		},
	},
}
