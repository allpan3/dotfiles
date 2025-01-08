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
	},
}
