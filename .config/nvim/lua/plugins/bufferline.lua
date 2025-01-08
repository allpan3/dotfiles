-- TODO: see if there's a way to entirely remove tabs
return {
	"akinsho/bufferline.nvim",
	opts = {
		options = {
			-- mode = "tab", -- this hides buffers from line, only show tabs
			separator_style = "slant",
			numbers = function(opts)
				return string.format("%s·%s", opts.raise(opts.ordinal), opts.lower(opts.id))
			end,
			indicator = {
				style = "underline",
			},
			-- highlights = {
			-- },
			groups = {
				items = {
					require("bufferline.groups").builtin.pinned:with({ icon = "" }),
				},
			},
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "center",
					highlight = "Directory",
					separator = true,
				},
			},
			hover = {
				enabled = true,
				delay = 150,
				reveal = { "close" },
			},
		},
	},
	keys = {
		{ "<leader>bse", "<cmd>BufferLineSortByExtension<CR>", desc = "Sort by Extension" },
		{ "<leader>bsd", "<cmd>BufferLineSortByDirectory<CR>", desc = "Sort by Directory" },
		{ "<leader>bst", "<cmd>BufferLineSortByTabs<CR>", desc = "Sort" },
		{ "<leader>bb", "<cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
		{ "<leader>bh", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<leader>bl", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "<leader>br", false },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
	},
}
