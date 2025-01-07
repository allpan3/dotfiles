-- Keymaps are automatically loaded on the VeryLazy event
-- LazyVim default keymaps are automatically loaded: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

---------- Keys free to map -------------
-- key     mode      description
-- M        n         not useful
-- <C-r>    n         use U for redo
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

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
--   operator-pending = "o"

-- TODO: This function doesn't support icon, not sure which function I should use
vim.keymap.set("n", "<leader><space>", ":", { desc = "Command Mode" })
-- Edit
vim.keymap.del({ "n", "t" }, "<C-_>") -- neovim default is terminal
map({ "n", "i", "v", "x" }, "<C-_>", "<cmd>undo<CR>", { desc = "Undo" }) -- same as terminal
map({ "n", "i", "v", "x" }, "<M-r>", "<cmd>redo<CR>", { desc = "Redo" }) -- ctrl-r is search history in shell; this is mainly for mapping cmd-shift-z
map("n", "U", "<C-r>", { desc = "Redo" }) -- pair with u as undo; using ctrl-r instead of :redo allows count
map("n", "<S-enter>", "<cmd>put _<cr>") -- shift-enter to insert new line below in normal mode
map("i", "<M-e>", "<C-o>d$") -- delete to end of line, match shell (customized)

-- Indentation
-- Workaround: this mapping to itself is needed to seprate ctrl-i from tab even when CSI-u is enabled. Don't know why
map({ "n", "v", "x" }, "<c-i>", "<c-i>")
map("n", "<tab>", ">>", { desc = "Indent" })
map("n", "<S-tab>", "<<", { desc = "Unindent" })
map({ "v", "x" }, "<tab>", ">gv", { desc = "Indent" })
map({ "v", "x" }, "<S-tab>", "<gv", { desc = "Unindent" })

-- Tab management
-- LazyVim default uses <tab> as secondary key. I prefer to use t
-- Nvim doesn't have native support for showing only the buffers opened in each tab, but each tab maintains a window layout
-- I still almost never uses the native tabs in nvim
vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader><tab>o")
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
-- map("n", "<leader>to", "<cmd>tabnew %<CR>", { desc = "New Tab w/ Current Buffer" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })

-- Window management
vim.keymap.del("n", "<leader>-")
map("n", "<leader>wv", "<C-w>v", { desc = "Split Window Right" }) -- :vsplit
map("n", "<leader>ws", "<C-w>s", { desc = "Split window Below" }) -- :split
map("n", "<leader>w\\", "<C-W>v", { desc = "Split Window Right" })
map("n", "<leader>w|", "<C-W>s", { desc = "Split Window Below" })
map("n", "<leader>\\", "<C-W>v", { desc = "Split Window Right" })
map("n", "<leader>|", "<C-W>s", { desc = "Split Window Below" })
map("n", "<leader>w=", "<C-w>=", { desc = "Make Windows Equal Size" })
map("n", "<leader>wj", "<C-w>j", { desc = "Focus on Window Below" })
map("n", "<leader>wk", "<C-w>k", { desc = "Focus on Window Above" })
map("n", "<leader>wh", "<C-w>h", { desc = "Focus on Window Left" })
map("n", "<leader>wl", "<C-w>l", { desc = "Focus on Window Right" })
map("n", "<leader>wn", "<C-w>w", { desc = "Cycle Through Windows" })
map("n", "<leader>wts", "<C-w>t<C-w>K", { desc = "Change Vertical to Horizontal" })
map("n", "<leader>wtv", "<C-w>t<C-w>H", { desc = "Change Horizontal to Vertical" })
-- LazyVim default uses ctrl-arrow to resize windows. Use leader key instead
map("n", "<leader>w<Up>", "<cmd>resize -2<CR>", { desc = "Decrease Window Height" })
map("n", "<leader>w<Down>", "<cmd>resize +2<CR>", { desc = "Increase Window Height" })
map("n", "<leader>w<Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Window Width" })
map("n", "<leader>w<Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- Buffer management
-- LazyVim default is <leader>`
map("n", "<leader><tab>", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

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

-- Floating terminal
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")

-- Copy current file path
map("n", "<leader>fy", "<cmd>let @+ = expand('%:p')<cr>", { desc = "Copy File Path" })
vim.keymap.set("n", "<leader>fp", ":edit ", { desc = "Open Path" }) -- open file with absolute or relative path

-- LazyVim menu
vim.keymap.del("n", "<leader>l")
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>lx", "<cmd>LazyExtras<cr>", { desc = "Lazy Extras" })

-- Diagnostic
vim.keymap.set("n", "<leader>xf", vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })

-- LazyVim default to save
vim.keymap.del({ "i", "n", "x", "c" }, "<C-s>")

-- Lazygit
-- This shows all (up to a limit) history of the line
-- git log -L flag doesn't support uncommitted lines. It only sees the single revision (in this case the default is HEAD)
-- So this command is only reliable in unchanged files
map("n", "<leader>gB", function() LazyVim.lazygit.blame_line({count = 10}) end, { desc = "Blame Line History" })
-- Open git remote repo
map("n", "<leader>gH", LazyVim.lazygit.browse, { desc = "Git Remote Repo" })

-- TODO:: would like to achieve everything in cutlass in custom keymaps.
-- Cutlass has multiple bugs
map("x", "X", "D")
map("x", "d", '"_d')

-- zellij.vim - seamless navigation between nvim and zellij panes
-- stylua: ignore
map({"n"}, "<c-h>", "<cmd>ZellijNavigateLeft!<cr>", { desc = "Navigate Left" })
map({"n"}, "<c-l>", "<cmd>ZellijNavigateRight!<cr>", { desc = "Navigate Right" })
map({"n"}, "<c-j>", "<cmd>ZellijNavigateDown<cr>", { desc = "Navigate Down" })
map({"n"}, "<c-k>", "<cmd>ZellijNavigateUp<cr>", { desc = "Navigate Up" })


-- Toggle line numbers: swap LazyVim default mappings 
LazyVim.toggle.map("<leader>ul", LazyVim.toggle("relativenumber", { name = "Relative Number" }))
LazyVim.toggle.map("<leader>uL", LazyVim.toggle.number)

