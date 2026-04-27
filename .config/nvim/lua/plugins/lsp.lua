return {
	"neovim/nvim-lspconfig",
	opts = function(_, opts)
		local nvim_config = vim.fs.normalize(vim.fn.stdpath("config"))

		opts.servers.pyright = {
			-- Disable diagnostics for xsh files due to unsupported syntax.
			on_attach = function(client, bufnr)
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("%.xsh$") then
					vim.diagnostic.disable(bufnr)
				end
			end,
			settings = {
				pyright = {
					disableOrganizeImports = true,
				},
				-- python = {
				-- 	analysis = {
				-- 		-- Ignore all files for analysis to exclusively use Ruff for linting
				-- 		ignore = { "*" },
				-- 	},
				-- },
			},
		}

		opts.servers.marksman = {
			-- Disable diagnostics for markdown because markdownlint-cli2 reports too many unnecessary warnings.
			-- I don't want to disable markdownlint-cli2 altogether because of formatting.
			-- In the future may want to add a configuration for markdownlint-cli2 to customize the rules.
			-- There's a visible delay for diagnostics to be disabled.
			on_attach = function(client, bufnr)
				vim.diagnostic.disable(bufnr)
			end,
		}

		opts.servers.lua_ls = vim.tbl_deep_extend("force", opts.servers.lua_ls or {}, {
			root_dir = function(bufnr, on_dir)
				local filename = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
				if filename:sub(1, #nvim_config) == nvim_config then
					return on_dir(nvim_config)
				end

				local root = vim.fs.root(bufnr, {
					".luarc.json",
					".luarc.jsonc",
					".luacheckrc",
					".stylua.toml",
					"stylua.toml",
					"selene.toml",
					"selene.yml",
					".git",
				})
				if root then
					on_dir(root)
				end
			end,
		})
	end,
}
