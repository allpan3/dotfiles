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
    opts.servers.marksman = {
      -- Disable diagnostics for markdown because markdownlint-cli2 reports too many unnecessary warnings
      -- I don't want to disable markdownlint-cli2 altogether because of formatting
      -- In the future may want to add a configuration for markdownlint-cli2 to customize the rules
      -- There's a visible delay for diagnostics to be disabled
      on_attach = function(client, bufnr)
        vim.diagnostic.disable(bufnr)
      end,
    }
	end,
}
