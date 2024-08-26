return {
	{
		"EdenEast/nightfox.nvim",
		-- themes:
		--   nightfox
		--   dayfox
		--   carbonfox
		opts = {
			specs = {
				carbonfox = {
					syntax = {
						-- conditional = "magenta.bright",
						-- keyword = "magenta.base",
					},
				},
			},
			groups = {
				carbonfox = {
					WinSeparator = { fg = "palette.bg3" },
					FloatBorder = { fg = "palette.bg4" },
					MatchParen = { fg = "palette.pink", style = "bold,underline" }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
					-- Visual = { bg = spec.sel0 }, -- Visual mode selection (inverse won't work)
				},
			},
			palettes = {
				carbonfox = {
					comment = "#808892",
					sel0 = "#353535", -- visual
				},
			},
		},
	},
	{
		"allpan3/oxocarbon.nvim",
		-- I made the comment more readable
		-- Borderless
		-- flash label not very easy to see
		-- themes:
		--   oxocarbon
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "carbonfox",
			-- colorscheme = "catppuccin",
		},
	},
}
