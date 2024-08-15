-- Some behaviors are strange but it's the only plugin I found that doesn't create side buffers for centering purpose.
return {
	"folke/zen-mode.nvim",
	keys = {
		{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
	},
}
