return {
	-- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	lazy = false, -- this plugin does not support lazy loading
	build = ":TSUpdate",
	-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
	-- There are additional nvim-treesitter modules that you can use to interact
	-- with nvim-treesitter. You should go explore a few and see what interests you:
	--
	--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
	--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
	--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

	opts = {
		keys = {
			{ "<c-enter>", desc = "Increment Selection", mode = { "x", "n" } },
			{ "<bs>", desc = "Decrement Selection", mode = "x" },
		},
		incremental_selection = {
			enable = true,
			-- Ctrl-Enter to incrementally select, backspace to incrementally deselect
			keymaps = {
				init_selection = "<c-enter>", -- set to `false` to disable one of the mappings
				node_incremental = "<c-enter>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},
	},
}
