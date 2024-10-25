return {
	"max397574/better-escape.nvim",
  lazy = false,
	config = function()
		require("better_escape").setup({
			default_mappings = false,
			mappings = {
				i = {
					d = {
						-- These can all also be functions
						f = "<Esc>",
					},
				},
				c = {
					d = {
						-- These can all also be functions
						f = "<Esc>",
					},
				},
				-- t = {
				-- 	d = {
				-- 		-- These can all also be functions
				-- 		f = "<Esc>",
				-- 	},
				-- },
				v = {
          d = {
						-- These can all also be functions
            f = "<Esc>"
          }
				},
				s = {
          d = {
						-- These can all also be functions
            f = "<Esc>"
          }
				},
			},
		})
	end,
}
