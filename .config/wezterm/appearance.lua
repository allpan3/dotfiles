local wezterm = require("wezterm")
local scheme = wezterm.get_builtin_color_schemes()["carbonfox"]

----------------
-- Appearance --
----------------

-- Customize carbon fox color scheme
scheme.ansi = {
	"#282828",
	"#ee5396",
	"#25be6a",
	"#e5e575",
	"#78a9ff",
	"#be95ff",
	"#33b1ff",
	"#dfdfe0",
}

scheme.brights = {
	"#484848",
	"#f16da6",
	"#46c880",
	"#fffa44",
	"#8cb6ff",
	"#c8a5ff",
	"#52bdff",
	"#e4e4e5",
}

scheme.tab_bar = {
	inactive_tab = { bg_color = scheme.background, fg_color = "#b6b8bb" },
	-- The color of the inactive tab bar edge/divider
	inactive_tab_edge = "#808080",
}

-- TODO: hide tab close button should be available in the next release

return {
	-- color_scheme = "carbonfox",
	colors = scheme,
	-- font = wezterm.font("MesloLGS Nerd Font Mono"),
	font = wezterm.font("JetBrainsMono Nerd Font"),
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	font_size = 14,
	line_height = 0.85,
	cell_width = 1.0,
	adjust_window_size_when_changing_font_size = false,

	-- Tab bar
	-- use_fancy_tab_bar = false,
	-- config.enable_tab_bar = false
	hide_tab_bar_if_only_one_tab = true,
	-- config.tab_bar_at_bottom = true
	tab_max_width = 25,

	-- Fancy tab bar appearance
	window_frame = {
		font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Bold" }),
		-- Controls the size of tar bar
		font_size = 12,
		-- The overall background color of the tab bar when
		-- the window is focused
		active_titlebar_bg = "#1e1e1e",

		-- The overall background color of the tab bar when
		-- the window is not focused
		inactive_titlebar_bg = "#1e1e1e",
	},

	-- Hide window bar
	window_decorations = "RESIZE",

	-- The amount of padding between the window border and the terminal cells.
	window_padding = {
		left = 0,
		top = 0,
		bottom = 0,
		right = 0,
	},

	-- Inactive pane dimming
	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.9,
	},

	-- Scrollbar
	-- enable_scroll_bar = true,
}
