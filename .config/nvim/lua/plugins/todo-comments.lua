return {
	"folke/todo-comments.nvim",
	cmd = { "TodoTrouble", "TodoTelescope" },
	event = "LazyFile",
	opts = {
		keywords = {
			FIX = {
				icon = " ", -- icon used for the sign, and in search results
				color = "error", -- can be a hex color, or a named color (see below)
				alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "ERROR" }, -- a set of other keywords that all map to this FIX keywords
				-- signs = false, -- configure signs for some keywords individually
			},

			QUES = { icon = " ", color = "question", alt = { "QUESTION", "DOUBT", "UNSURE" } },
		},
		highlight = {
			before = "fg", -- "fg" or "bg" or empty
			keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
			pattern = [[.*<((KEYWORDS)\s*%(\(.{-1,}\))?)\s*:]],
			comments_only = false, -- uses treesitter to match keywords in comments only
		},
		search = {
			pattern = [[\b(KEYWORDS)\s*(\([^\)]*\))?\s*:]],
			command = "rg",
			args = {
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--hidden",
				"--no-ignore",
			},
		},

		-- list of named colors where we try to extract the guifg from the
		-- list of highlight groups or use the hex color if hl not found as a fallback
		colors = {
			question = { "#FBBF24" },
		},
	},
	-- stylua: ignore
	 keys = {
    -- { "<leader>st", function () Snacks.picker.todo_comments({}) end, desc = "TODO (buffer)" }, -- how to show only current buffer?
      -- { "<leader>sT", function() Snacks.picker.todo_comments({cwd = vim.fn.expand("%:p:h")}) end, desc = "TODO (cwd)" },
    { "<leader>se", function () Snacks.picker.todo_comments({ keywords = { "ERROR", "WARN", "WARNING" }}) end, desc = "Error/Warn (buffer)" }, 
    { "<leader>xt", "<cmd>Trouble todo toggle filter.buf=0<cr>", desc = "Trouble TODO (buffer)" },
    { "<leader>xT", "<cmd>Trouble todo toggle <cr>", desc = "Trouble TODO (cwd)" },
    { "<leader>xe", "<cmd>Trouble todo toggle filter = {tag = {ERROR,WARN,WARNING}, buf = 0}<cr>", desc = "Trouble Error/Warn (buffer)" },
	 }
,
}
