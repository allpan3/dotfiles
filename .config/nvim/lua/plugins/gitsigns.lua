return {
	{
		"lewis6991/gitsigns.nvim",
		event = "LazyFile",
		opts = {
			signs = {
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
      -- Enable this to override mini.diff's number, which doesn't have staged info
			numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
      -- signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`

      -- With this enabled, staged changes will be shown in darker color
      -- Select line and <leader>ga to stage partial hunks. Partial hunks cannot be unstaged (undo) by staging again.
			-- signs_staged_enable = false,

			attach_to_untracked = true,
			current_line_blame_opts = {
				-- ignore_whitespace = true,
				delay = 500,
			},
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

				map("n", "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]h", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, "Next Hunk")
				map("n", "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[h", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, "Prev Hunk")
				map("n", "]H", function()
					gs.nav_hunk("last")
				end, "Last Hunk")
				map("n", "[H", function()
					gs.nav_hunk("first")
				end, "First Hunk")
				map("n", "<leader>ga", gs.stage_hunk, "Stage Hunk")
				map("v", "<leader>ga", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage hunk")
				map("n", "<leader>gr", gs.reset_hunk, "Reset Hunk")
				-- unstaging a range currently doesn't work
				map("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset hunk")
				map("n", "<leader>gA", gs.stage_buffer, "Stage Buffer")
				map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk") -- this is not unstage, it only undo the last call of stage_hunk
        map("n", "<leader>gU", gs.reset_buffer_index, "Unstage Buffer")
				-- inline doesn't allow cursor movement
				map("n", "<leader>gp", gs.preview_hunk_inline, "Preview Hunk Inline")
				-- map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
				-- enter key chord twices to switch focus to the blame window, or do <leader>ww
				-- shows only the previous commit
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, "Blame Line")
        map("n", "<leader>gB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle Blame Inline")
				map("n", "<leader>gd", gs.diffthis, "Side-by-side Diff")
				map("n", "<leader>gtd", gs.toggle_deleted, "Toggle Diff")
				map("n", "<leader>gtw", gs.toggle_word_diff, "Toggle Word Diff")
				map("n", "<leader>gtl", gs.toggle_linehl, "Toggle Line Highlight")
				map("n", "<leader>gtn", gs.toggle_numhl, "Toggle Number Highlight") -- this is currently controlled by mini.diff so not working
				map("n", "<leader>gts", gs.toggle_signs, "Toggle Signcolumn")
				-- text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
	},
	{
		"folke/which-key.nvim",
		opts = {
			spec = {
				{ "<leader>gt", group = "toggle", mode = { "n", "v" } },
			},
		},
	},
}
