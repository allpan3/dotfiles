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
	--	{ "RRethy/vim-illuminate", opts = { under_cursor = false } },
	{ "mrjones2014/smart-splits.nvim",
    opts = {
      zellij_move_focus_or_tab = true,
    }
  },
	{
		"fei6409/log-highlight.nvim",
		lazy = false,
		config = function()
			require("log-highlight").setup({})
		end,
	},
	{
		"cappyzawa/trim.nvim",
		event = { "LazyFile" },
		opts = {
			trim_on_write = false,
			highlight = false,
		},
		keys = {
			{ "<leader>ct", "<cmd>Trim<CR>", desc = "Trim Whitespace" },
			{ "<leader>ut", "<cmd>TrimToggle<CR>", desc = "Toggle Trim On Save" },
		},
	},
}
