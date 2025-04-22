return {
	"zbirenbaum/copilot.lua",
	opts = function(_, opts)
		LazyVim.cmp.actions.ai_accept_line = function()
			if require("copilot.suggestion").is_visible() then
				LazyVim.create_undo()
				require("copilot.suggestion").accept_line()
				return true
			end
		end

		opts.suggestion.keymap = {
			accept = "<S-CR>",
			accept_line = false, -- use tab, configured in blink.lua so that it doesn't completely take over the default behavior
			accept_word = "<C-e>",
			next = "<M-]>",
			prev = "<M-[>",
      dismiss = "<C-g>"
		}
	end,
}
