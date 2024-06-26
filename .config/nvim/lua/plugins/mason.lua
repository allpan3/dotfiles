return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	opts = {
		ensure_installed = {
			"stylua",
			"shfmt",
			-- "flake8",
			"autotools-language-server",
			"bash-language-server",
			"clangd",
			"html-lsp",
			"json-lsp",
			"lua-language-server",
			"texlab",
			"pyright",
			"verible",
		},
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
}
