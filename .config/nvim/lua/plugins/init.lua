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
	{
		"fresh2dev/zellij.vim",
		lazy = false,
		init = function()
			-- Options:
			vim.g.zelli_navigator_move_focus_or_tab = 1
			-- vim.g.zellij_navigator_no_default_mappings = 1
		end,
		-- keys need to be set in the global keymaps to take precedence
	},
}
