return {
	{
		"gbprod/yanky.nvim",
		keys = {
			{ "<leader>p", false },
			{
				"<leader>pp",
				function()
					require("telescope").extensions.yank_history.yank_history({})
				end,
				desc = "Open Yank History",
			},
			{ "<leader>pr", "<cmd>YankyClearHistory<CR>", desc = "Clear Yank History" },
		},
	},
	{
		"folke/which-key.nvim",
		opts = function(_, opts)
			if LazyVim.has("yanky.nvim") then
        opts.defaults["<leader>p"] = { name = "+yanky" }
		 	end
		end,
	},
}
