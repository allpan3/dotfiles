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
      enabled = true
    },

		picker = {},

		explorer = {
			-- replace_netrw = true, -- Replace netrw with the snacks explorer
		},
	},

	keys = {
		{ "<leader><space>", false }, -- set to command mode
		-- Explorer
		{ "<leader>e", false },
		{ "<leader>E", false },
		{ "<leader>fe", false },
		{ "<leader>fE", false },
		{
			"<leader>ee",
			function()
				Snacks.explorer()
			end,
			desc = "File Explorer",
		},
		{
			"<leader>ee",
			function()
				Snacks.explorer({ cwd = LazyVim.root() })
			end,
			desc = "Explorer (root)",
		},
		{
			"<leader>eE",
			function()
				Snacks.explorer()
			end,
			desc = "Explorer (cwd)",
		},

		-- Picker
    -- git (some are set in keymaps.lua and gitsigns.lua)
    -- This shows the commit histories that contain this line, but shows all changes in the commit instead of just the hunk containing the line
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line"},
    { "<leader>gl", function() Snacks.picker.git_log({ cwd = LazyVim.root.git() }) end, desc = "Git Log (root)" },
    -- { "<leader>gL", function() Snacks.picker.git_log() end, desc = "Git Log (cwd)" }, -- Does this work?
    { "<leader>gc", false },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
		{ "<leader>gh", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gD", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
	},
}
