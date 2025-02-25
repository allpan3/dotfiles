return {
	"neovim/nvim-lspconfig",
	opts = function(_, opts)
		opts.servers.pyright = {
      -- Disable diagnostics for xsh files due to unsupported syntax
			on_attach = function(client, bufnr)
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("%.xsh$") then
					-- Disable diagnostics for this buffer without affecting formatting
					vim.diagnostic.disable(bufnr)
				else
					-- Your usual on_attach code here
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
	end,
}
