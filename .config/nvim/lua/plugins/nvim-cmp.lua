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

		opts.mapping = cmp.mapping.preset.insert({
			["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-s>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					if not cmp.close() then
						fallback()
					else
						cmp.close()
					end
				else
					if not cmp.complete() then
						fallback()
					else
						cmp.complete()
					end
				end
			end, { "i", "s" }),
			["<Tab>"] = cmp.mapping(function(fallback)
				-- cmp menu given the highest priority
				if cmp.visible() then
					cmp.confirm({ select = true }) -- accept the current selected item, otherwise have to press down to select the first item
				elseif require("copilot.suggestion").is_visible() and not beginning_of_line() then
					require("copilot.suggestion").accept()
				-- elseif luasnip.expandable() then
				--   luasnip.expand()
				-- elseif vim.snippet.active({ direction = 1 }) then
				-- 	vim.schedule(function()
				-- 		vim.snippet.jump(1)
				-- 	end)
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end, { "i", "s" }),
			-- 		["<S-CR>"] = cmp.confirm({
			-- 			behavior = cmp.ConfirmBehavior.Replace,
			-- 			select = false,
			-- 		}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			-- 		["<C-CR>"] = function(fallback)
			-- 			cmp.abort()
			-- 			fallback()
			-- 		end,
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
