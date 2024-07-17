return {
	"max397574/better-escape.nvim",
	config = function()
		require("better_escape").setup({
			default_mappings = false,
			mappings = {
				i = {
					f = {
						-- These can all also be functions
						d = "<Esc>",
					},
				},
				c = {
					f = {
						-- These can all also be functions
						d = "<Esc>",
					},
				},
				-- t = {
				-- 	f = {
				-- 		-- These can all also be functions
				-- 		d = "<Esc>",
				-- 	},
				-- },
				v = {
          f = {
						-- These can all also be functions
            d = "<Esc>"
          }
				},
				s = {
          f = {
						-- These can all also be functions
            d = "<Esc>"
          }
				},
			},
		})
	end,
}
