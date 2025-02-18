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
			["<C-e>"] = {},
			["<C-y>"] = {},
			["<C-g>"] = { "hide" },
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
			-- Don't use tab to complete ai ghost text - use <C-f> instead
			["<Tab>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_and_accept()
					end
				end,
				"snippet_forward",
				"fallback",
			},
		},
	},
}
