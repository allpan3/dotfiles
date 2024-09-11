-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- :help options

-- appearance
vim.opt.background = "dark" -- colorschemes that can be light or dark will be made dark
vim.opt.guifont = "monospace:h17" -- the font used in graphical neovim applications

-- line numbers
vim.opt.relativenumber = false -- show relative line numbers
vim.opt.numberwidth = 2 -- minimal number of columns to use for the line number {default 4}

-- tabs & indentation
vim.opt.shiftwidth = 2 -- number of spaces inserted for each indentation
vim.opt.autoindent = true -- copy indent from current line when starting a new one

-- display
vim.opt.pumblend = 10 -- popup menu opacity
-- opt.cmdheight = 2 -- more space in the neovim command line for displaying messages

-- editing
vim.opt.conceallevel = 2 -- so that `` is visible in markdown files
vim.opt.swapfile = false -- creates a swapfile

-- mouse event
vim.opt.mousemoveevent = true

-- run vimscript in lua file
vim.cmd("set whichwrap+=<,>,[,],h,l")
-- vim.cmd([[set iskeyword+=-]]) -- treat - as part of a word

-- Explorer
vim.cmd("let g:netrw_liststyle = 3") -- set Explorer to tree style

-- Disable autoformat on save
vim.g.autoformat = false

-- In case you don't want to use `:LazyExtras`,
-- then you need to set the option below.
vim.g.lazyvim_picker = "telescope"

-- OSC52 is supposed to be automatically detected when clipboard is set to "",
-- which then set it to "unnamedplus". But in the terminals/zellij I tried,
-- it shows "no clipboard tool found". I have to manually force it.
vim.opt.clipboard = "unnamedplus"

-- use unnamed register for paste
local function paste()
	local content = vim.fn.getreg("")
	return vim.split(content, "\n")
end

if vim.env.SSH_TTY then
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		-- In iTerm2, OSC52 works fine both ways.
		-- In wezterm, OSC52 isn't implemented for paste. see https://github.com/wez/wezterm/discussions/5231#discussioncomment-10066374
		-- Zellij doesn't support OSC52 for paste. see https://github.com/zellij-org/zellij/issues/2637
		-- So overall, have to use unnamed register for paste to work around the OSC52 issue, and use cmd-v for pasting anything from outside of vim.
		-- see https://github.com/neovim/neovim/discussions/28010
		-- (I would expect that I can just manually read the "+ register to get the content for paste, but somehow it's always empty.
		-- I have to read from unnamed register for paste instead. Still not clear about osc52 copy behavior. Seems like it's passing
		-- the value to system clipboard *outside* the ssh, but not writing to the "+ register in the remote.)
		paste = {
			-- ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			-- ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
			["+"] = paste,
			["*"] = paste,
		},
	}
end

-- Disable comment wrapping
-- vim.cmd('autocmd BufEnter * set formatoptions-=cro')
-- vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

-- Turn off key code timeout since we never type escape sequences manually
-- This fixes the ESC delay issue. This may also affect some other default key codes,
-- but I haven't used any of those so far.
-- Note: do not turn off ttimeout altogether. Some escape sequences are being typed at
-- neovim startup by some plugins, which is also affectd by ttimeout. But setting len to 0 works so far.
vim.cmd("set ttimeoutlen=0")
