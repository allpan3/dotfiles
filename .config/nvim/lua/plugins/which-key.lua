return {
	"folke/which-key.nvim",
	opts = {
		spec = {
			{ "<leader>t", group = "tabs" },
			{ "<leader><tab>", desc = "Switch to Other Buffer" }, -- Overrides LazyVim default
			{ "<leader>l", group = "lazy" },
			{ "<leader><space>", icon = "" }, 
		},
	},
}
