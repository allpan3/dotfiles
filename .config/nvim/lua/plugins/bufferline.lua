return {
	"akinsho/bufferline.nvim",
	opts = {
		options = {
			-- mode = "tab", -- this hides buffers from line, only show tabs
			separator_style = "slant",
			always_show_bufferline = false,
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
      -- stylua: ignore
      close_command = function(n) require("mini.bufremove").delete(n, false) end,
      -- stylua: ignore
      right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(_, _, diag)
				local icons = require("lazyvim.config").icons.diagnostics
				local ret = (diag.error and icons.Error .. diag.error .. " " or "")
					.. (diag.warning and icons.Warn .. diag.warning or "")
				return vim.trim(ret)
			end,
		},
	},
	keys = {
		{ "<leader>tr", ":BufferLineTabRename ", desc = "Rename Tab" },
		{ "<leader>bse", "<cmd>BufferLineSortByExtension<CR>", desc = "Sort by Extension" },
		{ "<leader>bsd", "<cmd>BufferLineSortByDirectory<CR>", desc = "Sort by Directory" },
		{ "<leader>bst", "<cmd>BufferLineSortByTabs<CR>", desc = "Sort" },
		{ "<leader>bg", "<cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
		{ "<leader>bh", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<leader>bl", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "<leader>br", false },
	},
}
