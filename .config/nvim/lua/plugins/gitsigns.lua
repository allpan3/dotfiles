return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

    -- stylua: ignore start
    -- vim.keymap.del({ "n", "v" }, "<leader>ga")
    map("n", "[h", gs.prev_hunk, "Prev Hunk")
    map("n", "]h", gs.next_hunk, "Next Hunk")
    map({ "n", "v" }, "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk")
    map({ "n", "v" }, "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk")
    map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
    map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
    map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
    map("n", "<leader>gp", gs.preview_hunk_inline, "Preview Hunk Inline")
    map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
    map('n', '<leader>gtb', gs.toggle_current_line_blame, "Toggle Blame")
    map("n", "<leader>gd", gs.diffthis, "Diff This")
    map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff This ~")
    map('n', '<leader>gtd', gs.toggle_deleted, "Toggle Diff")

    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
	},
	{
		"folke/which-key.nvim",
		opts = function(_, opts)
			if LazyVim.has("gitsigns.nvim") then
				opts.defaults["<leader>gh"] = { name = "" } -- removes LazyVim default name
				opts.defaults["<leader>gt"] = { name = "+toggle" }
			end
		end,
	},
}
