return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = "nvim-tree/nvim-web-devicons",
		lazy = false,
		config = function()
			local nvimtree = require("nvim-tree")
			local cmd = require("nvim-tree.commands")

			-- Recommended settings from nvim-tree documentation
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			nvimtree.setup({
				view = {
					width = 30,
					-- relativenumber = true,
				},
				renderer = {
					indent_markers = {
						enable = true,
					},
					-- Set custom icons
					icons = {
						glyphs = {
							folder = {
								arrow_closed = "", -- arrow when folder is closed
								arrow_open = "", -- arrow when folder is open
							},
						},
					},
				},
				-- Disable window_picker for explorer to work well with window splits
				actions = {
					open_file = {
						window_picker = {
							enable = false,
						},
					},
				},
				filters = {
					custom = { ".DS_Store" },
				},
				git = {
					ignore = true,
					enable = true,
				},
			})

			-- Set keymaps
			vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" }) -- toggle file explorer
			vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Reveal File in Explorer" }) -- toggle file explorer on current file
			vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse Folders" }) -- collapse file explorer
			vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh File Explorer" }) -- refresh file explorer
		end,
	},
	{
		"folke/which-key.nvim",
		opts = {
			spec = {
				{ "<leader>e", group = "explorer", icon = { icon = "", color = "cyan" }, mode = { "n", "v" } },
			},
		},
	},
}
