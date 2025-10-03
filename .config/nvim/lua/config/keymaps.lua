-- Keymaps are automatically loaded on the VeryLazy event
-- LazyVim default keymaps are automatically loaded: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

---------- Keys free to map -------------
-- key        mode      description
-- M           n         not useful
-- <C-r>       n         use U for redo
-- <C-/>       n         unbound
-- <leader>`   n         switch buffer, redundant
-----------------------------------------

-- remap: recursively map the keys when the rhs contains lhs
-- silent: when mapping a key to a command, don't show the command prompt popup
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- remap: recursively map the keys when the rhs contains lhs
-- silent: when mapping a key to a command, don't show the command prompt popup
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
--   operator-pending = "o"

vim.keymap.set({"n", "v"}, "<leader><space>", ":", { desc = "Command Mode" })

-- Floating terminal, handle <C-/>
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")
-- Since I barely use neovim builtin float terminal, prefer to leave <C-/> for other keybindings
vim.keymap.del({ "n", "t" }, "<C-/>") -- neovim default is terminal
vim.keymap.del({ "n", "t" }, "<C-_>") -- neovim default is terminal
-- This is required to makes ctrl-/ mappable in terminal mode programs (like fzf). https://github.com/neovim/neovim/issues/18735#issuecomment-1136527335
-- map("t", "<C-/>", "<C-_>")

-- Edit
map({ "n", "i", "v", "x" }, "<C-_>", "<cmd>undo<CR>", { desc = "Undo" }) -- same as terminal
map({ "n", "i", "v", "x" }, "<M-r>", "<cmd>redo<CR>", { desc = "Redo" }) -- ctrl-r is search history in shell; this is mainly for mapping cmd-shift-z
map("n", "U", "<C-r>", { desc = "Redo" }) -- pair with u as undo; using ctrl-r instead of :redo allows count
map("n", "<S-enter>", "<cmd>put _<cr>") -- shift-enter to insert new line below in normal mode
map("i", "<M-h>", "<C-o>d$") -- delete to end of line, match shell (customized)
map("i", "<M-d>", "<C-o>db") -- delete word forward, match shell (customized for vi mode)

-- Indentation
-- <tab> and ctrl-i are distinguished if both are unmapped or both are mapped. So here we map ctrl-i to itself.
-- however in insert and terminal mode ctrl-i seems to be equivalent to <tab>
map({ "n", "v", "x" }, "<c-i>", "<c-i>")
map("n", "<tab>", ">>", { desc = "Indent" })
map("n", "<S-tab>", "<<", { desc = "Unindent" })
map({ "v", "x" }, "<tab>", ">gv", { desc = "Indent" })
map({ "v", "x" }, "<S-tab>", "<gv", { desc = "Unindent" })

-- Tab management
-- LazyVim default uses <tab> as secondary key.
-- Nvim doesn't have native support for showing only the buffers opened in each tab, but each tab maintains a window layout, so it's useless
vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader><tab>o")
vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>[")
vim.keymap.del("n", "<leader><tab>d")

-- Window management
vim.keymap.del("n", "<leader>|")
map("n", "<leader>\\", "<C-w>v", { desc = "Split Window Right" })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below" })
map("n", "<leader>wb", "<C-w>s", { desc = "Split Window Below" })
map("n", "<leader>wn", "<C-w>w", { desc = "Cycle Through Windows" })
map("n", "<leader>wth", "<C-w>t<C-w>K", { desc = "Change Vertical to Horizontal" })
map("n", "<leader>wtv", "<C-w>t<C-w>H", { desc = "Change Horizontal to Vertical" })
map("n", "<leader>`", "<cmd>wincmd p<CR>", { desc = "Switch to Other Window" })

-- Buffer management
map("n", "<leader><tab>", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" }) -- LazyVim default is <leader>`

-- Save File
map({ "n", "x", "s" }, "<leader>fs", "<cmd>w<CR>", { desc = "Save File" })
vim.keymap.set({ "n", "x", "s" }, "<leader>fS", ":w ", { desc = "Save as" })

-- Clear Highlight
-- LazyVim configures <esc> to clear highlight in both insert and normal mode.
-- I prefer to keep it when I exit from insert to normal, but only clear when press <esc> in normal mode
vim.keymap.del({ "i" }, "<esc>")

-- Navigation
map("n", "<M-f>", "e") -- word forward, match terminal; <M-b> is word backward by default
map({ "n", "v", "x", "o" }, "gh", "^", { desc = "Goto Beginning of Indented Line" })
-- in visual mode $ includes the new line char, which isn't consistent with other operator mode
-- using g_ excludes the new line char, better consistency
map({ "n", "v", "x", "o" }, "gl", "g_", { desc = "Goto End of Line" })
map("i", "<M-b>", "<S-left>") -- word backward, match shell (shift-left is neovim default)
map("i", "<M-f>", "<S-right>") -- word forward, match shell (shift-right is neovim default)

-- Save and quite
map("n", "<leader>qw", "<cmd>wq<cr>", { desc = "Save and Quit" })

-- By default, pasting in visual mode puts the replaced text in default register. This writes to blackhole register instead
-- both p and P work
map({ "v", "x" }, "p", '"_dP', { desc = "Replace with Paste" })

-- Copy current file path
map("n", "<leader>fy", "<cmd>let @+ = expand('%:p')<cr>", { desc = "Copy File Path" })
vim.keymap.set("n", "<leader>fe", ":edit ", { desc = "Open Path" }) -- open file with absolute or relative path

-- LazyVim menu
vim.keymap.del("n", "<leader>l")
vim.keymap.del("n", "<leader>L")
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>lx", "<cmd>LazyExtras<cr>", { desc = "Lazy Extras" })
map("n", "<leader>lg", function()
	LazyVim.news.changelog()
end, { desc = "LazyVim Changelog" })

-- LazyVim default to save
vim.keymap.del({ "i", "n", "x", "s" }, "<C-s>")

-- Git
-- This shows all (up to a limit) history of the line
-- git log -L flag doesn't support uncommitted lines. It only sees the single revision (in this case the default is HEAD)
-- So this command is only reliable in unchanged files
-- NOTE: very hard to use this view
-- map("n", "<leader>gB", function()
-- 	Snacks.git.blame_line({ count = 10 })
-- end, { desc = "Blame Line History" })
-- Open git remote repo
map({ "n", "x" }, "<leader>gH", function()
	Snacks.gitbrowse()
end, { desc = "Open Remote Repo" })
map({"n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
end, { desc = "Copy Repo URL" })
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gg", function() Snacks.lazygit( { cwd = LazyVim.root.git() }) end, { desc = "Lazygit (root)" })
  map("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
end


-- TODO:: would like to achieve everything in cutlass in custom keymaps.
-- Cutlass has multiple bugs
map("x", "X", "D")
map("x", "d", '"_d')

-- Toggle line numbers: swap LazyVim default mappings
Snacks.toggle.line_number():map("<leader>uL")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>ul")

-- smart-split.vim 
-- seamless navigation between nvim and zellij panes
map('n', '<C-h>', require('smart-splits').move_cursor_left)
map('n', '<C-j>', require('smart-splits').move_cursor_down)
map('n', '<C-k>', require('smart-splits').move_cursor_up)
map('n', '<C-l>', require('smart-splits').move_cursor_right)
map('n', '<C-\\>', require('smart-splits').move_cursor_previous)
-- swapping buffers between windows
map('n', '<leader>vh', require('smart-splits').swap_buf_left, {desc = "Swap Buffer Left"})
map('n', '<leader>vj', require('smart-splits').swap_buf_down, {desc = "Swap Buffer Down"})
map('n', '<leader>vk', require('smart-splits').swap_buf_up, {desc = "Swap Buffer Up"})
map('n', '<leader>vl', require('smart-splits').swap_buf_right, {desc = "Swap Buffer Right"})
-- resizing windows
map('n', '<leader>wh', require('smart-splits').resize_left)
map('n', '<leader>wj', require('smart-splits').resize_down)
map('n', '<leader>wk', require('smart-splits').resize_up)
map('n', '<leader>wl', require('smart-splits').resize_right)
