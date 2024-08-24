-- In normal mode, I almost never use default f/t, and even enhanced f/t is not
-- as useful as jump.
-- In operand pending mode, f is more precise than jump
-- (jump is difficult to select to the exact position, and search range is more
-- limited because it searches both directions), but I still almost never uses
-- f/t. f/t gives the most precise control but treesitter/treesitter_search is
-- sufficient most of the time.
-- So I deactivate default f/t and use the f and t keys for jump and treesitter.
--
-- Modification:
-- Normal mode: Use s for jump, S continues last jump search
--              f for char, f for char backward,
--              t for treesitter forward, T for treesitter backward
--              treesitter changed to jump instead of select - use vt for selection.
--              R for reference jump
-- Visual and/or Operand Pending mode:
--              s for jump forward, S for jump backward. They are modified to properly
--              select to the beginning/end of the word.
--              t for local tree select, T for remote tree select.
--              r for remote flash. It's useful because cursor position restores after
--              action (cannot achieve the same with treesitter search)
--

-- Operand Pending mode: f/t use <enter> to complete
return {
	"folke/flash.nvim",
	keys = {
		-- first match can be jumped to with <enter>
		{
			"s",
			mode = { "n" },
			function()
        -- jump to the beginning of the match makes more sense
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"S",
			mode = { "n" },
			function()
				require("flash").jump({ continue = true })
			end,
			desc = "Flash Last Search",
		},
		-- in visual and operator pending mode, separate forward and backward to make it always select the whole word we intend to
		{
			"s",
			mode = { "x", "o" },
			function()
				require("flash").jump({
					search = { forward = true, wrap = false, multi_window = false },
					jump = { pos = "end" },
				})
			end,
			desc = "Flash Forward",
		},
		{
			"S",
			mode = { "x", "o" },
			function()
				require("flash").jump({
					search = { forward = false, wrap = false, multi_window = false },
					jump = { pos = "start" },
				})
			end,
			desc = "Flash Backward",
		},
		-- treesitter pair have the same label so have to separate forward and backword
		{
			"t",
			mode = { "n" },
			function()
				require("flash").treesitter({ jump = { pos = "end" }, label = { before = false, after = true } })
			end,
			desc = "Flash Treesitter",
		},
		{
			"T",
			mode = { "n" },
			function()
				require("flash").treesitter({ jump = { pos = "start" }, label = { before = true, after = false } })
			end,
			desc = "Flash Treesitter",
		},
		{
			"t",
			mode = { "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
		-- this is basically remote treesitter, but somehow cursor doesn't restore
		{
			"T",
			mode = { "x", "o" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search",
		},
		{ "r", mode = { "o", "x" }, false },
		{ "R", mode = { "o", "x" }, false },
		-- action on some remote text and flash back to original position
		-- the operator (have to press first) is acted on the remote text
		-- this only works in operating pending mode. Would be useful if it can work in visual
		-- mode (select first then decide the operator)
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
		},
		{
			"R",
			mode = "n",
			function()
				local params = vim.lsp.util.make_position_params()
				params.context = {
					includeDeclaration = true,
				}
				local first = true
				local bufnr = vim.api.nvim_get_current_buf()
				vim.lsp.buf_request(bufnr, "textDocument/references", params, function(_, result, ctx)
					if not vim.islist(result) then
						result = { result }
					end
					if first and result ~= nil and not vim.tbl_isempty(result) then
						first = false
					else
						return
					end
					require("flash").jump({
						mode = "references",
						search = { incremental = true },
						matcher = function(win)
							local oe = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
							return vim.tbl_map(function(loc)
								return {
									pos = { loc.lnum, loc.col - 1 },
									end_pos = { loc.end_lnum or loc.lnum, (loc.end_col or loc.col) - 1 },
								}
							end, vim.lsp.util.locations_to_items(result, oe))
						end,
					})
				end)
			end,
			desc = "Flash Reference",
		},
		{ "<c-s>", false },
	},
	opts = {
		jump = {
      -- this breaks f somehow - once goes forward cannot go backward properly. Removing it and overriding in each keymap
			-- pos = "end",
      -- jump doesn't support next/prev action. Would be nice to have
		},
		modes = {
			-- search mode label disappears after pressing <enter>, which makes it useless for me
			search = {
				enabled = false,
			},
			char = {
				-- Enable label for f/t mode. count can prefix the f/t (e.g. 2f<x>) or postfix (e.g. f<x>2f), both are not as nice as repeatedly pressing
				-- I think no label is cleaner - I use jump for for complex movement anyways. However, when no label we cannot repeatedly use f/t as
				-- motion in operand pending mode (feels like a bug), e.g. df<x>ffff doesn't work - the moment we hit <x> it completes deletion
				-- With label on we don't see this bug.
				jump_labels = true,
				-- don't think having both f and t is necessary. When need finer control, use f in v mode then fine tune with h/l, followed by desired x/d/c/y action
				keys = { "f", "F" },
			},
			treesitter_search = {
				remote_op = { restore = true }, -- restore is not working
			},
		},
		label = {
			rainbow = { enabled = true, shade = 2 },
		},
	},
}
