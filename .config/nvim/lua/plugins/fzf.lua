-- fzf uses neovim's terminal mode, hence there's no modal edit (maybe there's a way to enable?)
-- both fzf and zellij seem to not support CSI-u at the moment, so avoid using conflicting ctrl sequences
return {
	"ibhagwan/fzf-lua",
	opts = function(_, opts)
		local actions = require("fzf-lua.actions")

		-- opts.fzf_opts = {
		-- }

		opts.keymap = {
			builtin = {
				false, -- remove defaults
				["<C-->"] = "toggle-help",
				["<C-d>"] = "preview-page-down",
				["<C-u>"] = "preview-page-up",
				["<C-/>"] = "toggle-preview",
				["<M-/>"] = "toggle-preview-wrap",
				["<M-]>"] = "toggle-preview-ccw",
				["<M-[>"] = "toggle-preview-cw",
			},
			-- these are fzf --bind options
			fzf = {
				false, -- remove defaults
				["ctrl-z"] = "abort",
				["ctrl-c"] = "unix-line-discard",
				["alt-a"] = "toggle-all",
				["alt-g"] = "first",
				["alt-G"] = "last",
				["ctrl-x"] = "jump",
				["ctrl-q"] = "select-all+accept",
				-- non-builtin previewer such as bat won't inherit the key's set above. Need separate commands set here
				["ctrl-d"] = "preview-page-down",
				["ctrl-u"] = "preview-page-up",
				["ctrl-/"] = "toggle-preview", -- this requires mapping C-/ to C-_ in terminal mode, see keymaps.lua
        ["alt-/"] = "toggle-preview-wrap",
			},
		}

		opts.files = {
			cwd_prompt = false,
			fzf_opts = {
				["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history",
			},
			actions = {
				["ctrl-g"] = { actions.toggle_ignore },
				["ctrl-h"] = { actions.toggle_hidden },
			},
		}

		opts.grep = {
			fzf_opts = {
				["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
			},
			actions = {
				["ctrl-l"] = { actions.grep_lgrep },
				["ctrl-g"] = { actions.toggle_ignore },
				["ctrl-h"] = { actions.toggle_hidden },
			},
		}
	end,
	keys = {
		{ "<leader><space>", false }, -- disable, set in keymaps.lua
		{ "<leader>gh", "<cmd>FzfLua git_branches<CR>", desc = "List Branches" },
		{ "<leader>gS", "<cmd>FzfLua git_blame<CR>", desc = "Blame File" },
		{ "<leader>gs", "<cmd>FzfLua git_stash<CR>", desc = "List Stash" },
		{ "<leader>gc", "<cmd>FzfLua git_bcommits<CR>", desc = "File Commit History" },
		{ "<leader>gC", "<cmd>FzfLua git_commits<CR>", desc = "Repo Commit History" },
	},
}
