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

		local set_picker = function()
			if vim.fn.executable("fd") == 1 then
				return {
					"fd",
					"--hidden",
					"--type=f",
					"--ignore",
				}
			else
				return {
					"rg",
					"--hidden",
					"--ignore",
					"--files",
				}
			end
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
				-- open files in the first window that is an actual file.
				-- use the current window if no other window is available.
				get_selection_window = function()
					local wins = vim.api.nvim_list_wins()
					table.insert(wins, 1, vim.api.nvim_get_current_win())
					for _, win in ipairs(wins) do
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.bo[buf].buftype == "" then
							return win
						end
					end
					return 0
				end,
				mappings = {
					i = {
						["<c-t>"] = open_with_trouble,
						-- ["<a-t>"] = open_selected_with_trouble,
						["<a-i>"] = find_files_no_ignore,
						["<a-h>"] = find_files_with_hidden,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
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
			pickers = {
				find_files = {
					find_command = set_picker()
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
