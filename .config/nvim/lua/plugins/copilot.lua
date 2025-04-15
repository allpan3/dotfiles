return {
	"zbirenbaum/copilot.lua",
	opts = {
		suggestion = {
			keymap = {
				accept = "<S-CR>",
        accept_line = false, -- use tab, configured in blink.lua so that it doesn't completely take over the default behavior
        accept_word = "<C-e>",
				next = "<M-]>",
				prev = "<M-[>",
			},
		},
	},
}
