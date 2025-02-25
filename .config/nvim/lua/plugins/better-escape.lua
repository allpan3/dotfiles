return {
	"max397574/better-escape.nvim",
  lazy = false,
	config = function()
		require("better_escape").setup({
			default_mappings = false,
			mappings = {
				i = {
					j = {
						-- These can all also be functions
						k = "<Esc>",
					},
				},
				c = {
					j = {
						-- These can all also be functions
						k = "<Esc>",
					},
				},
				-- t = {
				-- 	j = {
				-- 		-- These can all also be functions
				-- 		k = "<Esc>",
				-- 	},
				-- },
				v = {
          j = {
						-- These can all also be functions
            k = "<Esc>"
          }
				},
				s = {
          j = {
						-- These can all also be functions
            k = "<Esc>"
          }
				},
			},
		})
	end,
}
