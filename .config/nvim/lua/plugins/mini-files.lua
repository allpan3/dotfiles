return {
	"echasnovski/mini.files",
	opts = {
		windows = {
			preview = true,
			width_focus = 30,
			width_preview = 50,
		},
		options = {
      -- FIX: this doesn't work for me. Still uses netrw or nvim-tree
			use_as_default_explorer = true,
		},
	},
	keys = {
    {"<leader>fm", false},
    {"<leader>fM", false},
		{
			"<leader>em",
			function()
				require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
			end,
			desc = "mini.files (cwd)",
		},
		{
			"<leader>eM",
			function()
				require("mini.files").open(vim.uv.cwd(), true)
			end,
			desc = "mini.files (root)",
		},
	},
}
