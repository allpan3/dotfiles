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
    opts = {
      spec = {
        { "<leader>p", group = "yanky", icon = { icon = "󰅇", color = "yellow" }, mode = {"n", "v"} },
      },
    },
	},
}
