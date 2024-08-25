return {
	"rmagatti/auto-session",
	lazy = false,
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_save_enabled = true,
			auto_restore_enabled = false, -- don't automatically restore session; restore with SPC sr
			auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/", "/" },
			-- auto_session_use_git_branch = true,

			-- ⚠️  This will only work if Telescope.nvim is installed
			-- The following are already the default values, no need to provide them if these are already the settings you want.
			session_lens = {
				-- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
				buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
				load_on_setup = true,
				theme_conf = { border = true },
				previewer = false,
			},
		})

		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

		vim.keymap.set("n", "<leader>qs", "<cmd>SessionSave<CR>", { desc = "Save Session" })
		vim.keymap.set(
			"n",
			"<leader>qf",
			require("auto-session.session-lens").search_session,
			{ desc = "Search Session", noremap = true }
		)
		vim.keymap.set("n", "<leader>ql", "<cmd>SessionRestore<CR>", { desc = "Restore Session" })
		vim.keymap.set("n", "<leader>qd", "<cmd>SessionDelete<CR>", { desc = "Delete Session" })
	end,
}
