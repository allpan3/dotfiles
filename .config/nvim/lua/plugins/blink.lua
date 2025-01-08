return {
	"saghen/blink.cmp",
	opts = {
		completion = {
			keyword = { range = "full" },
			-- list = {
			-- 	selection = { preselect = true, auto_insert = false },
			-- },
		},

		keymap = {
			preset = "super-tab",
			["Esc"] = { "hide", "fallback" },
			-- ["<C-k>"] = { "select_prev", "fallback" }, -- this somwhow doesn't work
			-- ["<C-j>"] = { "select_next", "fallback" },
			["<C-s>"] = {
				function(cmp)
					if cmp.is_visible() then
						return cmp.cancel()
					else
						return vim.schedule(function()
							cmp.show()
							cmp.show_documentation()
							cmp.hide_documentation()
						end)
					end
				end,
			},
		},
	},
}
