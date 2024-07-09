return {
	"williamboman/mason.nvim",
	opts = {
		ensure_installed = {
			"stylua",
			"shfmt",
			"bash-language-server",
			"clangd",
			"html-lsp",
			"json-lsp",
			"lua-language-server",
			"pyright",
			"verible",
			"autotools-language-server",
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
