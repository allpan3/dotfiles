return {
	"neovim/nvim-lspconfig",
	opts = function(_, opts)
		opts.servers.pyright.settings = {
			pyright = {
				disableOrganizeImports = true,
			},
			-- python = {
			-- 	analysis = {
			-- 		-- Ignore all files for analysis to exclusively use Ruff for linting
			-- 		ignore = { "*" },
			-- 	},
			-- },
		}
	end,
}
