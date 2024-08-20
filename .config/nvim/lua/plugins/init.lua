if vim.fn.has("nvim-0.9.0") == 0 then
	vim.api.nvim_echo({
		{ "LazyVim requires Neovim >= 0.9.0\n", "ErrorMsg" },
		{ "Press any key to exit", "MoreMsg" },
	}, true, {})
	vim.fn.getchar()
	vim.cmd([[quit]])
	return {}
end

require("lazyvim.config").init()

return {
	{ "folke/lazy.nvim", version = "*" },
	{ "LazyVim/LazyVim", priority = 10000, lazy = false, config = true, cond = true, version = "*" },
	{ "nvim-neo-tree/neo-tree.nvim", enabled = false }, -- use nvim-tree instead, more lightweight
	{ "folke/persistence.nvim", enabled = false }, -- use auto-session instead
	{
    "allpan3/zellij-nav.nvim",
		lazy = true,
		event = "VeryLazy",
		keys = {
			{ "<c-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "Navigate Left" } },
			{ "<c-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "Navigate Down" } },
			{ "<c-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "Navigate Up" } },
			{ "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "Navigate Right" } },
		},
		opts = {},
	},
	-- { "folke/noice.nvim", enabled = false },
}
