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
	{ "RRethy/vim-illuminate", opts = { under_cursor = false } },
	{
		"allpan3/zellij-nav.nvim",
		lazy = true,
		event = "VeryLazy",
		keys = {
			{
				"<c-h>",
				function()
					require("zellij-nav").left("move-focus-or-tab")
				end,
				{ silent = true, desc = "Navigate Left" },
			},
			{
				"<c-j>",
				function()
					require("zellij-nav").down("move-focus")
				end,
				{ silent = true, desc = "Navigate Down" },
			},
			{
				"<c-k>",
				function()
					require("zellij-nav").up("move-focus")
				end,
				{ silent = true, desc = "Navigate Up" },
			},
			{
				"<c-l>",
				function()
					require("zellij-nav").right("move-focus-or-tab")
				end,
				{ silent = true, desc = "Navigate Right" },
			},
		},
	},
	-- { "folke/noice.nvim", enabled = false },
}
