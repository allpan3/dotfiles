return {
	"nvim-telescope/telescope.nvim",

	opts = function()
		local actions = require("telescope.actions")

		local open_with_trouble = function(...)
			return require("trouble.providers.telescope").open_with_trouble(...)
		end
		local find_files_no_ignore = function()
			local action_state = require("telescope.actions.state")
			local line = action_state.get_current_line()
			LazyVim.pick("find_files", { no_ignore = true, default_text = line })()
		end
		local find_files_with_hidden = function()
			local action_state = require("telescope.actions.state")
			local line = action_state.get_current_line()
			LazyVim.pick("find_files", { hidden = true, default_text = line })()
		end

		return {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				entry_prefix = "  ", -- string in front of every entry (excluding current selection)
				vimgrep_arguments = {
					"rg",
					"--hidden",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--ignore",
				},
				winblend = 0, -- how transparent is the telescope window should be
				color_devicons = true,
				-- border = {},
				layout_strategy = "horizontal", -- how the telescope is drawn
				layout_config = { -- extra settings for fine-tuning how your layout looks
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
					},
					vertical = {
						mirror = false,
					},
					width = 0.87,
					height = 0.80,
					preview_cutoff = 80,
				},
				mappings = {
					i = {
						["<c-t>"] = open_with_trouble,
						-- ["<a-t>"] = open_selected_with_trouble,
						["<a-i>"] = find_files_no_ignore,
						["<a-h>"] = find_files_with_hidden,
						["<C-j>"] = actions.move_selection_next,       -- this overrides default keymap
						["<C-k>"] = actions.move_selection_previous,   -- this overrides default keymap
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["<C-f>"] = actions.preview_scrolling_down,
						["<C-b>"] = actions.preview_scrolling_up,
						["<C-s>"] = actions.select_horizontal, -- open selection in horizontal split
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- use <tab> to select lines, then send to quick fix list
					},
					n = {
						["q"] = actions.close,
						["<C-s>"] = actions.select_horizontal, -- open selection in horizontal split
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
					},
				},
			},
		}
	end,
	keys = {
		{ "<leader><space>", false },
		{ "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Find Buffers" },
		{ "<leader>gc", false }, -- don't seem useful
		{ "<leader>gs", false }, -- don't seem useful
		{
			"<leader>uc",
			LazyVim.pick("colorscheme", { enable_preview = true }),
			desc = "Colorscheme with Preview",
		},
	},
}
