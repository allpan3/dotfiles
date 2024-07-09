return {
	"hrsh7th/nvim-cmp",
	opts = function(_, opts)
		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
		local cmp = require("cmp")
		local defaults = require("cmp.config.default")()

		-- Toggle complete menu with one key
		local toggle_complete = function()
			return function(fallback)
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
			end
		end

		opts.mapping = cmp.mapping.preset.insert({
			-- TODO: want to remove C-n/C-p altogether, but currently API doesn't seem to expose this (auto-merges)
      -- May be a way to directly overwrite the whole mapping
			-- ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			-- ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-c>"] = toggle_complete(), -- both show and abort; somehow S-space don't work anymore
			["<Tab>"] = cmp.mapping.confirm({ select = true }), -- accept the current selected item, otherwise have to press down to select the first item
			["<S-CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			["<C-CR>"] = function(fallback)
				cmp.abort()
				fallback()
			end,
		})

    -- opts.cmdline(':', {
    --   mapping = cmp.mapping.preset.insert()
    -- })
	end
}
