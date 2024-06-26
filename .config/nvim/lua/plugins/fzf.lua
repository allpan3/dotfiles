return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")
			-- calling `setup` is optional for customization
			fzf.setup({})

			vim.keymap.set("n", "<leader>zf", "<cmd>FzfLua files<CR>", { silent = true, desc = "Find Files" })
		end,
	},
	{
		"folke/which-key.nvim",
		opts = function(_, opts)
			opts.defaults["<leader>z"] = { name = "+fzf" }
		end,
	},
}
