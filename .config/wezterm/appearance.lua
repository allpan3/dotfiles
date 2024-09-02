local wezterm = require("wezterm")
local scheme = wezterm.get_builtin_color_schemes()["Dark+"]

----------------
-- Appearance --
----------------
return {
	color_scheme = "Dark+",
	-- font = wezterm.font("MesloLGS Nerd Font Mono"),
	font = wezterm.font("JetBrainsMono Nerd Font"),
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
	font_size = 14,
  line_height = 0.85,
  cell_width = 1.0,
  adjust_window_size_when_changing_font_size = false,

	-- Tab bar
	use_fancy_tab_bar = false,
	-- config.enable_tab_bar = false
	hide_tab_bar_if_only_one_tab = true,
	-- config.tab_bar_at_bottom = true
	tab_max_width = 25,

	-- Fancy tab bar appearance
	window_frame = { font_size = 12 },

	-- Retro tab bar appearance
	-- colors = {
	-- 	tab_bar = {
	-- 		background = scheme.background,
	-- 		new_tab = { bg_color = "#2e3440", fg_color = scheme.ansi[8], intensity = "Bold" },
	-- 		new_tab_hover = { bg_color = scheme.ansi[1], fg_color = scheme.brights[8], intensity = "Bold" },
	-- 		-- format-tab-title
	-- 		-- active_tab = { bg_color = "#121212", fg_color = "#FCE8C3" },
	-- 		-- inactive_tab = { bg_color = scheme.background, fg_color = "#FCE8C3" },
	-- 		-- inactive_tab_hover = { bg_color = scheme.ansi[1], fg_color = "#FCE8C3" },
	-- 	},
	-- },

	-- The amount of padding between the window border and the terminal cells.
	window_padding = {
		left = 0,
		top = 0,
		bottom = 0,
		right = 0,
	},

	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.9,
	},

	-- Scrollbar
	-- enable_scroll_bar = true,
}
