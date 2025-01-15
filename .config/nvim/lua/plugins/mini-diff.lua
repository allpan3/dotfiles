-- Enable this plugin mainly for the overlay feature.
-- Want to keep using gitsigns so don't enable this plugin in LazyVim extra
return {
	"echasnovski/mini.diff",
	event = "VeryLazy",
	opts = {
		view = {
      -- Setting this to number (and the default priority) somehow fixes the partial hunk signcolumn issue in gitsigns
			style = "number",
			priority = 199,
			signs = {
				add = "▎",
				change = "▎",
				delete = "",
			},
		},
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
