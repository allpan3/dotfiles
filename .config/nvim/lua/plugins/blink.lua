return {
	"saghen/blink.cmp",
	opts = {
		completion = {
			keyword = { range = "full" },
			list = {
				selection = { preselect = false, auto_insert = false },
			},
		},
		keymap = {
			preset = "super-tab",
			["Esc"] = { "hide", "fallback" },
			["<C-e>"] = {},
			["<C-g>"] = { "hide", "fallback" },
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
			["<Tab>"] = {
        "accept",
				LazyVim.cmp.map({ "snippet_forward", "ai_accept_line" }),
				"fallback",
			},
		},
	},
}

