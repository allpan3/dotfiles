return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		spec = {
			mode = { "n", "v" },
			{ "<leader>t", group = "tabs" },
			{"<leader><tab>", group = "" }, -- removes LazyVim default name
		},
	},
}
