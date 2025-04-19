return {
	"snacks.nvim",
	opts = {
		dashboard = {
			-- width = 100,
			preset = {
				header = [[
                                                                   
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
]],
			},
			sections = {
				{ pane = 1, section = "header" },
				{ pane = 1, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ pane = 1, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
				{ pane = 1, section = "keys", gap = 1, padding = 1 },
				{ pane = 1, section = "startup" },
				-- { pane = 2, section = "terminal", cmd = "echo ' '", padding = 1 },
			},
		},

		-- Don't know what this does
		statuscolumn = {
			enabled = true,
		},

		picker = {
			sources = {
				files = { hidden = true },
				grep = { hidden = true },
				explorer = { hidden = true },
			},
			formatters = {
				file = {
					-- filename_first = true, -- show the filename first
					truncate = 10000, -- prevent path truncation
				},
			},
			win = {
				-- input window
				input = {
					keys = {
						-- WARN: would prever to use ctrl-i/h/l for toggling ignored, hidden, follow (link), but fzf doesn't seem to
						--       support CSI u, and better to match fzf and snacks picker
						["<c-n>"] = { "history_forward", mode = { "i", "n" } },
						["<c-p>"] = { "history_back", mode = { "i", "n" } },
            -- a-h is used by zellij
            ["<a-g>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<a-h>"] = false,
            -- With zellij kitty keyboard protocol disabled, <c-/> is the same as <c-_> in neovim, which is reserved by undo
						-- ["<c-/>"] = { "toggle_preview", mode = { "i", "n" } },
						["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
            -- Right now there's no action to directly toggle preview wrap, have to switch to preview window then <leader>uw
					},
				},
				-- result list window
				-- INFO: once enter list or preview window, can use all normal mode keybings (including leader keys)
				list = {
					keys = {
						-- ["<c-/>"] = "toggle_preview",
						["<c-t>"] = "trouble_open",
            -- a-h is used by zellij
            ["<a-g>"] = "toggle_hidden",
            ["<a-h>"] = false,
					},
					-- wo = {
					-- 	wrap = true,
					-- },
				},
				-- preview window
				preview = {
					keys = {
						-- ["<c-/>"] = "toggle_preview",
					},
				},
			},

			explorer = {
				git_status_open = true,
				-- diagnostics_open = true,
			},
		},

		explorer = {
			-- replace_netrw = false, -- Replace netrw with the snacks explorer
		},
	},

	-- stylua: ignore
	keys = {
		{ "<leader><space>", false }, -- set to command mode
		{ "<leader>,", false }, -- leave for something else
    { "<leader>*", LazyVim.pick("grep_word"), desc = "Grep Word (root) (", mode = { "n", "x" } },

		-- Explorer
		{ "<leader>e", false },
		{ "<leader>E", false },
		{ "<leader>fe", false },
		{ "<leader>fE", false },
		{ "<leader>ee", function() Snacks.explorer() end, desc = "File Explorer", },
		{ "<leader>ee", function() Snacks.explorer({ cwd = LazyVim.root() }) end, desc = "Explorer (root)", },
		{ "<leader>eE", function() Snacks.explorer() end, desc = "Explorer (cwd)", },

		-- Picker
    -- files
    -- use <M-c> to toggle between cwd and root
		{ "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (root)" },
    { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (cwd)" },
    -- grep
    { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    { "<leader>sG", LazyVim.pick("live_grep"), desc = "Grep (root)" },
    { "<leader>sw", LazyVim.pick("grep_word", { root = false }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
    { "<leader>sW", LazyVim.pick("grep_word"), desc = "Visual selection or word (root)", mode = { "n", "x" } },

   
		-- git (some are set in keymaps.lua and gitsigns.lua)
		-- This shows the commit histories that contain this line, but shows all changes in the commit instead of just the hunk containing the line
		{
			"<leader>gL",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Git Log Line",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log({ cwd = LazyVim.root.git() })
			end,
			desc = "Git Log (root)",
		},
		-- { "<leader>gL", function() Snacks.picker.git_log() end, desc = "Git Log (cwd)" }, -- Does this work?
		{ "<leader>gc", false },
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Git Log File",
		},
		{
			"<leader>gh",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Git Branches",
		},
		{
			"<leader>gD",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git Diff (Hunks)",
		},
	},
}
