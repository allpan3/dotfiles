return {
	{
		"shortcuts/no-neck-pain.nvim",
		version = "*", -- stable version
		opts = {
			-- width = 120,
			autocmds = {
				enableOnVimEnter = false,
			},
			mappings = {
				enabled = true,
				toggle = "<leader>zz",
				widthUp = "<leader>z=",
				widthDown = "<leader>z-",
				scratchPad = "<leader>zs",
				toggleLeftSide = "<leader>zl",
				toggleRightSide = "<leader>zr",
			},
			buffer = {
				scratchPad = {
					enabled = false, -- auto-saving
				},
			},
		},
	},
	{
		"folke/which-key.nvim",
		opts = {
			spec = {
				{ "<leader>z", group = "zenmode", icon = { icon = "", color = "cyan" }, mode = { "n", "v" } },
			},
		},
	},
}
