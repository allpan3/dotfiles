local wezterm = require('wezterm')
local config = wezterm.config_builder()
local utils = require('utils')

-- Appearance
local appearance = require('appearance')
config = utils.merge_tables(config, appearance)

-- Bindings
local bindings = require('bindings')
config.disable_default_key_bindings = true
config.keys = bindings.keys

-- Multiplexing
config.unix_domains = {
  {
    name = 'unix',
  },
}

-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
config.default_gui_startup_args = { 'connect', 'unix' }

return config


