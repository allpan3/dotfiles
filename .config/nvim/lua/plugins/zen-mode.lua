-- Some behaviors are strange but it's the only plugin I found that doesn't create side buffers for centering purpose.
-- Many actions are not registered - they exit the zen mode but don't do anything else.
-- For example, gd to go to definiton doesn't work here but works in true-zen.nvim.
return {

	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
				-- height and width can be:
				-- * an absolute number of cells when > 1
				-- * a percentage of the width / height of the editor when <= 1
				-- * a function that returns the width or the height
				width = 100, -- width of the Zen window
				height = 0.9, -- height of the Zen window
				-- by default, no options are changed for the Zen window
				-- uncomment any of the options below, or add other vim.wo options you want to apply
				options = {
					signcolumn = "no", -- disable signcolumn
					number = false, -- disable number column
					-- relativenumber = false, -- disable relative numbers
					-- cursorline = false, -- disable cursorline
					-- cursorcolumn = false, -- disable cursor column
					-- foldcolumn = "0", -- disable fold column
					-- list = false, -- disable whitespace characters
				},
			},
			plugins = {
				-- disable some global vim options (vim.o...)
				-- comment the lines to not apply the options
				options = {
					enabled = true,
					ruler = false, -- disables the ruler text in the cmd line area
					showcmd = false, -- disables the command in the last line of the screen
					-- you may turn on/off statusline in zen mode by setting 'laststatus'
					-- statusline will be shown only if 'laststatus' == 3
					laststatus = 0, -- turn off the statusline in zen mode
				},
				twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
				gitsigns = { enabled = false }, -- disables git signs
				tmux = { enabled = false }, -- disables the tmux statusline
				todo = { enabled = false }, -- if set to "true", todo-comments.nvim highlights will be disabled
				-- this will change the font size on wezterm when in zen mode
				-- see alse also the Plugins/Wezterm section in this projects README
				-- until passthrough is supported by zellij, this won't work in zellij
				wezterm = {
					enabled = true,
					-- can be either an absolute font size or the number of incremental steps
					font = "+4", -- (10% increase per step)
				},
			},
		},

		keys = {
			{ "<leader>zz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
		},
	},
	{
		"folke/twilight.nvim",
		opts = {
			dimming = {
				alpha = 0.3, -- amount of dimming
				-- we try to get the foreground from the highlight groups or fallback color
				color = { "Normal", "#ffffff" },
				term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
				inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
			},
			context = 15, -- amount of lines we will try to show around the current line
			treesitter = true, -- use treesitter when available for the filetype
			-- treesitter is used to automatically expand the visible text,
			-- but you can further control the types of nodes that should always be fully expanded
			expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
				"function",
				"method",
				"table",
				"if_statement",
			},
			exclude = {}, -- exclude these filetypes
		},
    keys = {
      { "<leader>zl", "<cmd>Twilight<cr>", desc = "Twilight" },
    },
	},
}
