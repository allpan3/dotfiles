local wezterm = require("wezterm")
local config = wezterm.config_builder()
local utils = require("utils")

-- General
config.enable_csi_u_key_encoding = true
config.allow_win32_input_mode = false
-- config.debug_key_events = true

-- Appearance
local appearance = require("appearance")
config = utils.merge_tables(config, appearance)

-- Title
-- local function get_process(tab)
-- 	-- if not tab.active_pane or tab.active_pane.foreground_process_name == "" then
-- 	-- 	return nil
-- 	-- end
--
-- 	-- local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
--
-- 	local process_name = tab.active_pane.user_vars.PROG
-- 	wezterm.log_info(tab.active_pane.user_vars.PROG)
-- 	-- return process_icons[process_name] or string.format('[%s]', process_name)
-- 	return string.format("[%s]", process_name)
-- end

local function get_cwd_basename(tab)
	local current_dir = tab.active_pane.current_working_dir
  local basename = ""
  -- Sometimes current_dir is nil or empty string. Not sure why
  if current_dir and current_dir ~= "" then
	  basename = string.match(current_dir.file_path, "([^/]+)$")
    local HOME_DIR = os.getenv("HOME") .. "/"
    basename = current_dir.file_path == HOME_DIR and "~" or basename
  end
  return basename
end

local function get_process(tab)
	-- TODO: I want to get the process name, but it's not working. Workaround by getting it from the default title
	local process = tab.active_pane.title
	return process
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.tab_title

	if title and #title > 0 then
	-- if the tab title is explicitly set, take that
	else
		local cwd_basename = get_cwd_basename(tab) or ""
		if cwd_basename ~= "" then
			cwd_basename = "[" .. cwd_basename .. "]"
		end

		title = (get_process(tab) or "") .. cwd_basename
	end

	local color = "#b7bdf8"

	if tab.is_active then
		return {
			{ Background = { Color = color } },
			{ Foreground = { Color = "black" } },
			{ Text = " " .. tab.tab_index + 1 .. ":" .. title .. " " },
		}
	else
		return {
			{ Text = " " .. tab.tab_index + 1 .. ":" .. title .. " " },
		}
	end
end)

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = "[Z] "
	end

	local path = ""
	if pane.current_working_dir then
		path = "[" .. pane.current_working_dir.file_path .. "]"
	end

	local title = (get_process(tab) or "") .. path

	return zoomed .. title
end)

-- Bindings
local bindings = require("bindings")
config.disable_default_key_bindings = true
config.keys = bindings.keys
config.mouse_bindings = bindings.mouse_bindings

-- Multiplexing
config.unix_domains = {
	{
		name = "unix",
	},
}

-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
config.default_gui_startup_args = { "connect", "unix" }


-- neovim zen-mode integration, allow it to change font size
wezterm.on('user-var-changed', function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == "ZEN_MODE" then
        local incremental = value:find("+")
        local number_value = tonumber(value)
        if incremental ~= nil then
            while (number_value > 0) do
                window:perform_action(wezterm.action.IncreaseFontSize, pane)
                number_value = number_value - 1
            end
            overrides.enable_tab_bar = false
        elseif number_value < 0 then
            window:perform_action(wezterm.action.ResetFontSize, pane)
            overrides.font_size = nil
            overrides.enable_tab_bar = true
        else
            overrides.font_size = number_value
            overrides.enable_tab_bar = false
        end
    end
    window:set_config_overrides(overrides)
end)

return config
