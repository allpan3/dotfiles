return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		local icons = LazyVim.config.icons
		-- opts.options.globalstatus = false
		-- opts.options.ignore_focus = { "NvimTree" }

		opts.extensions = {
			"nvim-tree",
			"trouble",
			"lazy",
			"fzf",
			-- "mason"
			-- "quickfix"
		}

		-- Winbar
		-- opts.winbar = {
		-- 	lualine_a = {},
		-- 	lualine_b = {},
		-- 	lualine_c = { "filename" },
		-- 	lualine_x = {},
		-- 	lualine_y = {},
		-- 	lualine_z = {},
		-- }
		--
		-- opts.inactive_winbar = {
		-- 	lualine_a = {},
		-- 	lualine_b = {},
		-- 	lualine_c = { "filename" },
		-- 	lualine_x = {},
		-- 	lualine_y = {},
		-- 	lualine_z = {},
		-- }

		opts.sections.lualine_c = {
			{
				"diagnostics",
				symbols = {
					error = icons.diagnostics.Error,
					warn = icons.diagnostics.Warn,
					info = icons.diagnostics.Info,
					hint = icons.diagnostics.Hint,
				},
			},
			-- Show root even if it's the same as cwd for consistency
			LazyVim.lualine.root_dir({ cwd = true }),
			-- { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{ LazyVim.lualine.pretty_path(), padding = { left = 1, right = 1 } },
		}

		-- do not add trouble symbols if aerial is enabled
		-- And allow it to be overriden for some buffer types (see autocmds)
		if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
			local trouble = require("trouble")
			local symbols = trouble.statusline({
				mode = "symbols",
				groups = {},
				title = false,
				filter = { range = true },
				format = "{kind_icon}{symbol.name:Normal}",
				hl_group = "lualine_c_normal",
			})
			table.insert(opts.sections.lualine_c, {
				symbols and symbols.get,
				cond = function()
					return vim.b.trouble_lualine ~= false and symbols.has()
				end,
			})
		end

		opts.sections.lualine_x = {
			-- Show formatter
			-- {
			-- 	function()
			-- 		-- Check if 'conform' is available
			-- 		local status, conform = pcall(require, "conform")
			-- 		if not status then
			-- 			return "Conform not installed"
			-- 		end
			--
			-- 		local lsp_format = require("conform.lsp_format")
			--
			-- 		-- Get formatters for the current buffer
			-- 		local formatters = conform.list_formatters_for_buffer()
			-- 		if formatters and #formatters > 0 then
			-- 			local formatterNames = {}
			--
			-- 			for _, formatter in ipairs(formatters) do
			-- 				table.insert(formatterNames, formatter)
			-- 			end
			--
			-- 			return "󰷈 " .. table.concat(formatterNames, " ")
			-- 		end
			--
			-- 		-- Check if there's an LSP formatter
			-- 		local bufnr = vim.api.nvim_get_current_buf()
			-- 		local lsp_clients = lsp_format.get_format_clients({ bufnr = bufnr })
			--
			-- 		if not vim.tbl_isempty(lsp_clients) then
			-- 			return "󰷈 LSP Formatter"
			-- 		end
			--
			-- 		return ""
			-- 	end,
			-- },
			{
				"filetype",
				colored = true,
			},
        -- stylua: ignore
				{
					"searchcount",
					maxcount = 999,
					timeout = 500,
          color = function() return { fg = Snacks.util.color("Special") } end,
				},
        -- stylua: ignore
        -- still unsure what this does
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          color = function() return { fg = Snacks.util.color("Constant") } end,

        },
        -- stylua: ignore
        {
          function() return "  " .. require("dap").status() end,
          cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
          color = function() return { fg = Snacks.util.color("Debug") } end,
        },
        -- stylua: ignore
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = function() return { fg = Snacks.util.color("Special") } end,
        },
			{
				"diff",
				symbols = {
					added = icons.git.added,
					modified = icons.git.modified,
					removed = icons.git.removed,
				},
				source = function()
					local gitsigns = vim.b.gitsigns_status_dict
					if gitsigns then
						return {
							added = gitsigns.added,
							modified = gitsigns.changed,
							removed = gitsigns.removed,
						}
					end
				end,
			},
		}

		opts.sections.lualine_y = {
			{ "progress", separator = "/", padding = { left = 1, right = 0 } },
			-- show line count and size, total and selection count
			-- disable showcmd since it also shows selection info
			{
				function()
					local starts = vim.fn.line("v")
					local ends = vim.fn.line(".")
					local wc = vim.fn.wordcount()
					if vim.fn.mode():find("[Vv]") then
						local count = starts <= ends and ends - starts + 1 or starts - ends + 1
						local bytes = wc["visual_bytes"] > 1024
								and string.format("%.1f", wc["visual_bytes"] / 1024) .. "k"
							or wc["visual_bytes"]
						return count .. "L/" .. bytes
					else
						local count = vim.fn.line("$")
						local bytes = wc["bytes"] > 1048576 and string.format("%.1f", wc["bytes"] / 1048576) .. "M"
							or wc["bytes"] > 1024 and string.format("%.1f", wc["bytes"] / 1024) .. "K"
							or wc["bytes"] .. "B"
						return count .. "L/" .. bytes
					end
				end,
				padding = { left = 0, right = 1 },
			},
		}

		-- Copilot status, since lualine_x is overridden, Lazyvim copilot extra won't take effect. Manuaully add it here
		table.insert(
			opts.sections.lualine_x,
			1,
			LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
				local clients = package.loaded["copilot"] and LazyVim.lsp.get_clients({ name = "copilot", bufnr = 0 })
					or {}
				if #clients > 0 then
					local status = require("copilot.api").status.data.status
					return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
				end
			end)
		)
	end,
}
