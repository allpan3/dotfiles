-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- :help options
local opt = vim.opt -- for conciseness

-- appearance
-- opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.guifont = "monospace:h17" -- the font used in graphical neovim applications

-- line numbers
opt.relativenumber = true -- show relative line numbers by default
opt.numberwidth = 2 -- minimal number of columns to use for the line number {default 4}

-- tabs & indentation
opt.tabstop = 2 -- number of space inserted for a tab
opt.shiftwidth = 2 -- number of spaces inserted for each indentation
opt.autoindent = true -- copy indent from current line when starting a new one

-- display
opt.pumblend = 10 -- popup menu opacity
-- opt.cmdheight = 2 -- more space in the neovim command line for displaying messages

-- editing
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.swapfile = false -- creates a swapfile

-- mouse event
opt.mousemoveevent = true

-- run vimscript in lua file
vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]]) -- treat - as part of a word

-- Explorer
vim.cmd("let g:netrw_liststyle = 3") -- set Explorer to tree style

-- Disable autoformat on save
vim.g.autoformat = false

-- In case you don't want to use `:LazyExtras`,
-- then you need to set the option below.
vim.g.lazyvim_picker = "telescope"
