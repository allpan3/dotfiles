-- Keymaps are automatically loaded on the VeryLazy event
-- LazyVim default keymaps are automatically loaded: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
--   operator-pending = "o"

vim.cmd("map <leader><space> :")

-- Edit
map({ "n", "i", "v", "x" }, "<C-_>", "<cmd>undo<CR>") -- looks like not working in command mode (undo buffer instead of command)
-- redo: map S-C-z to C-r
map("n", "<S-Enter>", "o<Esc>")

-- Tab management
-- LazyVim default uses <tab> as secondary key. I prefer to use t
-- Nvim doesn't have native support for showing only the buffers opened in each tab.
-- but each tab maintains a window layout
vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>[")
vim.keymap.del("n", "<leader><tab>d")
map("n", "<leader>te", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader>ta", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader>tt", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader>tl", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader>th", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader>to", "<cmd>tabnew %<CR>", { desc = "New Tab w/ Current Buffer" })

-- Window management
map("n", "<leader>wv", "<C-w>v", { desc = "Split Window Right" }) -- :vsplit
map("n", "<leader>ws", "<C-w>s", { desc = "Split window Below" }) -- :split
map("n", "<leader>w\\", "<C-W>v", { desc = "Split Window Right" })
map("n", "<leader>w|", "<C-W>s", { desc = "Split Window Below" })
map("n", "<leader>\\", "<C-W>v", { desc = "Split Window Right" })
map("n", "<leader>|", "<C-W>s", { desc = "Split Window Below" })
vim.keymap.del("n", "<leader>-")
vim.keymap.del("n", "<leader>w-")
map("n", "<leader>w=", "<C-w>=", { desc = "Make Windows Equal Size" })
-- LazyVim default uses ctrl-hjkl to move around windows
map("n", "<leader>wj", "<C-w>j", { desc = "Focus on Window Below" })
map("n", "<leader>wk", "<C-w>k", { desc = "Focus on Window Above" })
map("n", "<leader>wh", "<C-w>h", { desc = "Focus on Window Left" })
map("n", "<leader>wl", "<C-w>l", { desc = "Focus on Window Right" })
map("n", "<leader>wn", "<C-w>w", { desc = "Cycle Through Windows" })
map("n", "<leader>ww", "<cmd>TmuxNavigatePrevious<CR>", { desc = "Switch to Other Window" })
-- map("n", "<leader><tab>", "<cmd>TmuxNavigatePrevious<CR>", { desc = "Switch to Other Window" }) -- BUG: unsure why this doesn't work
map("n", "<leader>wts", "<C-w>t<C-w>K", { desc = "Change Vertical to Horizontal" }) -- change vertical to horizontal
map("n", "<leader>wtv", "<C-w>t<C-w>H", { desc = "Change Horizontal to Vertical" }) -- change horizontal to vertical

-- LazyVim default uses ctrl-arrow to rsize windows
map("n", "<leader>w<Up>", "<cmd>resize -2<CR>", { desc = "Decrease Window Height" })
map("n", "<leader>w<Down>", "<cmd>resize +2<CR>", { desc = "Increase Window Height" })
map("n", "<leader>w<Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Window Width" })
map("n", "<leader>w<Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- Save File
map({ "n", "x", "s" }, "<leader>fs", "<cmd>w<CR>", { desc = "Save File" })

-- Clear highlight
-- Disable LazyVim default hlsearch: don't want escaspe to clear highlight, use <leader>ur
vim.keymap.del({ "i", "n" }, "<esc>")

-- Navigation
map("n", "<M-f>", "e") -- word forward, match terminal
map("n", "gh", "0", { desc = "Goto Beginning of Line" })
map("n", "gl", "$", { desc = "Goto End of Line" })

-- Conceal level
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uC", function() LazyVim.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })

-- By default, pasting in visual mode puts the replaced text in register. This keeps the old text
map("v", "p", '"_dP')

-- Floating terminal
local lazyterm = function()
	LazyVim.terminal(nil, { cwd = LazyVim.root() })
end
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")
-- map("n", "<leader>t/", lazyterm, { desc = "Terminal (Root Dir)" })
-- map("n", "<leader>t?", function()
-- 	LazyVim.terminal()
-- end, { desc = "Terminal (cwd)" })
map("n", "<C-/>", lazyterm, { desc = "Terminal (Root Dir)" })
map("n", "<C-?>", function()
	LazyVim.terminal()
end, { desc = "Terminal (cwd)" })

