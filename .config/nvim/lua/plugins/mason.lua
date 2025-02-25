return {
	"williamboman/mason.nvim",
	opts = {
		ensure_installed = {
			"bash-language-server",
      "html-lsp",
      "json-lsp",
      "lua-language-server",
      "ruff",
      "shfmt",
			"stylua",
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
