local wezterm = require("wezterm")
local act = wezterm.action

local bindings = {}

bindings.keys = {
	{ key = "Enter", mods = "SUPER", action = act.ToggleFullScreen },
	{ key = "Enter", mods = "SHIFT|SUPER", action = act.TogglePaneZoomState },
	{ key = "-", mods = "SUPER", action = act.DecreaseFontSize },
	{ key = "+", mods = "SUPER", action = act.IncreaseFontSize },
	{ key = "0", mods = "SUPER", action = act.ResetFontSize },
	{ key = "1", mods = "SUPER", action = act.ActivateTab(0) },
	{ key = "2", mods = "SUPER", action = act.ActivateTab(1) },
	{ key = "3", mods = "SUPER", action = act.ActivateTab(2) },
	{ key = "4", mods = "SUPER", action = act.ActivateTab(3) },
	{ key = "5", mods = "SUPER", action = act.ActivateTab(4) },
	{ key = "6", mods = "SUPER", action = act.ActivateTab(5) },
	{ key = "7", mods = "SUPER", action = act.ActivateTab(6) },
	{ key = "8", mods = "SUPER", action = act.ActivateTab(7) },
	{ key = "9", mods = "SUPER", action = act.ActivateTab(-1) },
	{ key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
	{ key = "c", mods = "SHIFT|SUPER", action = act.ActivateCopyMode },
	{ key = "d", mods = "ALT|SUPER", action = act.ShowDebugOverlay },
  { key = "d", mods = "SUPER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "SHIFT|SUPER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
	{ key = "f", mods = "SUPER", action = act.Search({ CaseInSensitiveString = "" }) }, -- default is case-sensitive
	{ key = "h", mods = "SUPER", action = act.HideApplication },
  { key = "h", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(-1) },
	{ key = "k", mods = "SUPER", action = act.ClearScrollback("ScrollbackAndViewport") },
	{ key = "k", mods = "SHIFT|SUPER", action = act.ClearScrollback("ScrollbackOnly") },
	{ key = "l", mods = "SUPER", action = act.ShowLauncher },
  { key = "l", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(1) },
	{ key = "m", mods = "SUPER", action = act.Hide },
	{ key = "n", mods = "SUPER", action = act.SpawnWindow },
	{ key = "p", mods = "SUPER", action = act.ActivateCommandPalette },
	{ key = "q", mods = "SUPER", action = act.QuitApplication },
	{ key = "r", mods = "SUPER", action = act.ReloadConfiguration },
	{ key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "t", mods = "SHIFT|SUPER", action = act.SpawnTab("DefaultDomain") },
	{ key = "u", mods = "SUPER", action = act.CharSelect },
	-- TODO: would be great if there's a way to only confirm when there's a process running (like iTerm)
	{ key = "w", mods = "SUPER", action = act.CloseCurrentPane({ confirm = true }) }, -- closes the tab if last pane
	{ key = "x", mods = "SHIFT|SUPER", action = act.QuickSelect },
	{ key = "y", mods = "SUPER", action = act.SwitchWorkspaceRelative(1) },
	{ key = "[", mods = "SUPER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "SUPER", action = act.ActivateTabRelative(1) },
  { key = "[", mods = "SHIFT|ALT|SUPER", action = act.MoveTabRelative(-1) },
  { key = "]", mods = "SHIFT|ALT|SUPER", action = act.MoveTabRelative(1) },
	{ key = "{", mods = "SHIFT|SUPER", action = act.ActivatePaneDirection("Prev") }, -- somehow must be { instead of [
	{ key = "}", mods = "SHIFT|SUPER", action = act.ActivatePaneDirection("Next") },
	{ key = "PageUp", mods = "SUPER", action = act.ScrollByPage(-1) },
	{ key = "PageDown", mods = "SUPER", action = act.ScrollByPage(1) },
	{ key = "Copy", mods = "NONE", action = act.CopyTo("Clipboard") },
	{ key = "Paste", mods = "NONE", action = act.PasteFrom("Clipboard") },
	{ key = "LeftArrow", mods = "CTRL|SUPER", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "RightArrow", mods = "CTRL|SUPER", action = act.AdjustPaneSize({ "Right", 1 }) },
	{ key = "UpArrow", mods = "CTRL|SUPER", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "DownArrow", mods = "CTRL|SUPER", action = act.AdjustPaneSize({ "Down", 1 }) },
	-- Map SUPER to shell actions - ideally, use common keys/escape sequences shared by all shells
	-- (or customize them in shells). Configure the same in neovim
	{ key = "Backspace", mods = "SUPER", action = act.SendKey({ key = "u", mods = "CTRL" }) }, -- backward delete line
	{ key = "Backspace", mods = "ALT", action = act.SendKey({ key = "w", mods = "CTRL" }) }, -- backward delete word
	{ key = "Delete", mods = "SUPER", action = act.SendKey({ key = "e", mods = "ALT" }) }, -- forward delete line
	{ key = "Delete", mods = "ALT", action = act.SendString("\x1bd") }, -- forward delete word
	{ key = "LeftArrow", mods = "ALT", action = act.SendString("\x1bb") },
	{ key = "RightArrow", mods = "ALT", action = act.SendString("\x1bf") },
	-- { key = "LeftArrow", mods = "SUPER", action = act.SendKey {key = "a", mods = "CTRL"} },
	{ key = "LeftArrow", mods = "SUPER", action = act.SendString("\x1b[H") }, -- HOME
	-- { key = "RightArrow", mods = "SUPER", action = act.SendKey {key = "e", mods = "CTRL"} },
	{ key = "RightArrow", mods = "SUPER", action = act.SendString("\x1b[F") }, -- END
	{ key = "z", mods = "SUPER", action = act.SendKey({ key = "_", mods = "CTRL" }) }, -- undo
	{ key = "z", mods = "SHIFT|SUPER", action = act.SendKey({ key = "r", mods = "ALT" }) }, -- redo
}

bindings.mouse_bindings = {
	-- Plain click doesn't open link
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
	},
	-- Shift do not open link
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "SHIFT",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
	},
	-- Bind 'Up' event of Command-Click to open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "SUPER",
		action = act.OpenLinkAtMouseCursor,
	},
	-- Disable the 'Down' event of Command-Click to avoid weird program behaviors
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "SUPER",
		action = act.Nop,
	},
}

return bindings
