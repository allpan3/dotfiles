-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- :help options
local opt = vim.opt -- for conciseness

-- appearance
vim.opt.background = "dark" -- colorschemes that can be light or dark will be made dark
vim.opt.guifont = "monospace:h17" -- the font used in graphical neovim applications

-- line numbers
vim.opt.relativenumber = true -- show relative line numbers by default
vim.opt.numberwidth = 2 -- minimal number of columns to use for the line number {default 4}

-- tabs & indentation
vim.opt.shiftwidth = 3 -- number of spaces inserted for each indentation
vim.opt.autoindent = true -- copy indent from current line when starting a new one

-- display
vim.opt.pumblend = 10 -- popup menu opacity
-- opt.cmdheight = 2 -- more space in the neovim command line for displaying messages

-- editing
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.swapfile = false -- creates a swapfile

-- mouse event
vim.opt.mousemoveevent = true

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

-- Clipboard: this solves ssh clipboard issues
opt.clipboard = "unnamedplus"

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}

-- Disable comment wrapping
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')


