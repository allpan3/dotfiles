return {
	{
		"gbprod/yanky.nvim",
		keys = {
			{ "<leader>p", false },
			{
				"<leader>pp",
				function()
					if LazyVim.pick.picker.name == "telescope" then
						require("telescope").extensions.yank_history.yank_history({})
					else
						vim.cmd([[YankyHistory]])
					end
				end,
				mode = { "n", "x" },
				desc = "Open Yank History",
			},
			{ "<leader>pr", "<cmd>YankyClearHistory<CR>", desc = "Clear Yank History" },
      {"<c-p>", "<Plug>(YankyPreviousEntry)", mode = "n"},
      {"<c-n>", "<Plug>(YankyNextEntry)", mode = "n"},
		},
	},
	{
		"folke/which-key.nvim",
		opts = {
			spec = {
				{ "<leader>p", group = "yanky", icon = { icon = "󰅇", color = "yellow" }, mode = { "n", "v" } },
			},
		},
	},
}
