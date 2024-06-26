return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		defaults = {
			["<leader>t"] = { name = "+tabs" },
			["<leader><tab>"] = { name = "" }, -- removes LazyVim default name
		},
	},
}
