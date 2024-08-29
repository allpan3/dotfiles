return {
	"hrsh7th/nvim-cmp",
	opts = function(_, opts)
		local cmp = require("cmp")

		local function beginning_of_line()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col == 0 or vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:match("^%s+$") ~= nil
		end

		local function has_words_before()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		opts.auto_select = false
		opts.completion = {
			completeopt = "menu,menuone,noinsert,noselect",
		}
		opts.preselect = cmp.PreselectMode.None
		opts.window = {
			-- Make the completion menu bordered.
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		}
		opts.mapping = cmp.mapping.preset.insert({
			["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			-- this sometimes doesn't work for the first time; signature help took precedence over this, but it works the second menu is opened
			["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			-- toggle menu
			["<C-s>"] = cmp.mapping(function()
				if cmp.visible() then
					cmp.close()
				else
					cmp.complete()
				end
			end, { "i", "s" }),
			-- shift-space works in iTerm2, but still dones't work in wezterm even with CSI-u turned on
			["<S-space>"] = cmp.mapping(function()
				if cmp.visible() then
					cmp.close()
				else
					cmp.complete()
				end
			end, { "i", "s" }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() and cmp.get_active_entry() then
				  cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
				  -- select = true accepts the current selected item, otherwise have to press down to select the first item
          -- but it doesn't seem to matter when preselect is turned off
				-- When at beginning of the line, prefer to use <tab> for indentation
        elseif require("copilot.suggestion").is_visible() and not beginning_of_line() then
					require("copilot.suggestion").accept_line()
				-- elseif luasnip.expandable() then
				--   luasnip.expand()
				elseif vim.snippet.active({ direction = 1 }) then
					vim.schedule(function()
						vim.snippet.jump(1)
					end)
				-- use tab to invoke completion menu
				elseif has_words_before() then
					cmp.mapping.complete()
				else
					fallback()
				end
			end, { "i", "s" }),
		})

		-- TODO: still don't know how to configure both insert and cmdline mapping

		opts.experimental = {
			ghost_text = false, -- this feature conflict with copilot.vim's preview.
			-- ghost_text = {
			-- 	hl_group = "CmpGhostText",
			-- },
		}
	end,
}
