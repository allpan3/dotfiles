return {
	"nvim-telescope/telescope.nvim",

	opts = function()
		local actions = require("telescope.actions")

		local open_with_trouble = function(...)
			return require("trouble.providers.telescope").open_with_trouble(...)
		end
		-- TODO: these are not great because they (1) do not toggle (2) uses find_files no matter
		-- what the original picker is. It also ignores that options like cwd.
		local find_files_no_ignore = function()
			local action_state = require("telescope.actions.state")
			local line = action_state.get_current_line()
			LazyVim.pick("find_files", { no_ignore = true, default_text = line })()
		end
		local find_files_no_hidden = function()
			local action_state = require("telescope.actions.state")
			local line = action_state.get_current_line()
			LazyVim.pick("find_files", { hidden = false, default_text = line })()
		end

		-- Prioritize fd
		local function find_command()
			if 1 == vim.fn.executable("fd") then
				return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
			elseif 1 == vim.fn.executable("fdfind") then
				return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
			elseif 1 == vim.fn.executable("rg") then
				return { "rg", "--files", "--color", "never", "-g", "!.git" }
			elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
				return { "find", ".", "-type", "f" }
			elseif 1 == vim.fn.executable("where") then
				return { "where", "/r", ".", "*" }
			end
		end

		-- TODO: labels get laid out from top to bottom, which often misses the actual filtered entries, making this unsuable
		-- local function flash(prompt_bufnr)
		--      require("flash").jump({
		--        pattern = "^",
		--        label = { after = { 0, 0 } },
		--        search = {
		--          mode = "search",
		--          exclude = {
		--            function(win)
		--              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
		--            end,
		--          },
		--        },
		--        action = function(match)
		--          local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
		--          picker:set_selection(match.pos[1] - 1)
		--        end,
		--      })
		--  end

		return {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				entry_prefix = "  ", -- string in front of every entry (excluding current selection)
				vimgrep_arguments = {
					"rg",
					"--hidden",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--smart-case",
					"--column",
					"--ignore",
				},
				winblend = 0, -- how transparent is the telescope window should be
				color_devicons = true,
				layout_strategy = "horizontal", -- how the telescope is drawn
				-- layout_config = { -- extra settings for fine-tuning how your layout looks
				-- horizontal = {
				-- results get reduced to the bottom, so top prompt feels awkward
				-- 	prompt_position = "top",
				-- 	preview_width = 0.55,
				-- },
				-- vertical = {
				-- 	mirror = false,
				-- },
				-- width = 0.87,
				-- height = 0.80,
				-- preview_cutoff = 80,
				-- },
				mappings = {
					i = {
						["<C-t>"] = open_with_trouble, -- default is select_tab, I don't use nvim native tabs
						["<A-i>"] = find_files_no_ignore,
						["<A-h>"] = find_files_no_hidden,
						["<C-j>"] = actions.move_selection_next, -- this overrides default keymap
						["<C-k>"] = actions.move_selection_previous, -- this overrides default keymap
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["<C-f>"] = actions.preview_scrolling_right,
						["<C-b>"] = actions.preview_scrolling_left,
						["<C-l>"] = actions.results_scrolling_right,
						["<C-h>"] = actions.results_scrolling_left,
						["<C-s>"] = actions.select_horizontal, -- open selection in horizontal split
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- use <tab> to select lines, then send to quick fix list
						-- ["<C-s>"] = flash, TODO: need to resolve this key conflict
					},
					n = {
						["q"] = actions.close,
						["<A-i>"] = find_files_no_ignore,
						["<A-h>"] = find_files_no_hidden,
						["<C-s>"] = actions.select_horizontal, -- open selection in horizontal split
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["<C-f>"] = actions.preview_scrolling_right,
						["<C-b>"] = actions.preview_scrolling_left,
						["<C-l>"] = actions.results_scrolling_right,
						["<C-h>"] = actions.results_scrolling_left,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- use <tab> to select lines, then send to quick fix list
						-- ["s"] = flash,
					},
				},
			},
			pickers = {
				find_files = {
					find_command = find_command,
					hidden = true,
				},
			},
		}
	end,

	keys = {
		{ "<leader><space>", false },
		{ "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" }, -- cwd is the directory we open vim. Can navigate inside vim using :cd
		{ "<leader>fF", LazyVim.pick("files"), desc = "Find Files (root)" }, -- cwd is the directory we open vim. Can navigate inside vim using :cd
		{
			"<leader>fb",
			function()
				require("telescope.builtin").find_files({ cwd = require("telescope.utils").buffer_dir() })
			end,
			desc = "Find Files (Buf Dir)",
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").git_files()
			end,
			desc = "Git Files",
		},
		{ "<leader>bb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Find Buffer" },
		{ "<leader>gh", require("telescope.builtin").git_branches, desc = "List Branches" },
		{ "<leader>gs", require("telescope.builtin").git_stash, desc = "List Stash" },
		{ "<leader>gc", require("telescope.builtin").git_bcommits, desc = "File Commit History" },
		{ "<leader>gC", require("telescope.builtin").git_commits, desc = "Repo Commit History" }, -- this may be occasionally useful as we can search the commit message
		{ "<leader>/",  LazyVim.pick("live_grep", { root = false }), desc = "Grep (root)" },
		{ "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
		{ "<leader>sG", LazyVim.pick("live_grep"), desc = "Grep (root)" },
		{ "<leader>sw", LazyVim.pick("grep_string", { root = false, word_match = "-w" }), desc = "Word (cwd)" },
		{ "<leader>sW", LazyVim.pick("grep_string", { word_match = "-w" }), desc = "Word (root)" },
		{ "<leader>sw", LazyVim.pick("grep_string", { root = false }), mode = "v", desc = "Selection (cwd)" },
		{ "<leader>sW", LazyVim.pick("grep_string"), mode = "v", desc = "Selection (root)" },
	},
}
