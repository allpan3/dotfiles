return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")
			-- calling `setup` is optional for customization
			fzf.setup({})

			vim.keymap.set("n", "<leader>fz", "<cmd>FzfLua files<CR>", { silent = true, desc = "Find Files w/ fzf" })
		end,
	},
}
