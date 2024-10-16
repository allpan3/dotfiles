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
		"fresh2dev/zellij.vim",
    lazy = false,
    -- keys need to be set in the global keymaps to take precedence
	},
}
