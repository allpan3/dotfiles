return {
	"folke/which-key.nvim",
	opts = {
		spec = {
			{ "<leader><tab>", desc = "Switch to Other Buffer" }, -- Overrides LazyVim default
			{ "<leader>l", group = "lazy" },
      { "<leader>e", group = "explorer", icon = { icon = "", color = "cyan" }, mode = { "n", "v" } },
			{ "<leader><space>", icon = "" },
		},
	},
}
