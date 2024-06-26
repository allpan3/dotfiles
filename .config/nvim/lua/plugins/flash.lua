-- In normal mode, I almost never use default f/t, and even enhanced f/t is not
-- as useful as jump. In operand pending mode, f/t is more precise than jump
-- (jump is difficult to select to the exact position, and search range is more
-- limited because it searches both directions), but I still almost never uses
-- f/t. f/t gives the most precise control but treesitter/treesitter_search is 
-- sufficient most of the time.
-- So I deactivate default f/t and use the f and t keys for jump and treesitter.
--
-- Modification:
-- Normal mode: Use f for jump, t for treesitter forward, T for treesitter backward.
--              treesitter changed to jump instead of select - use vt for selection.
--              F continues last jump search
-- Visual and/or Operand Pending mode:
--              f for jump forward, F for jump backward. They are modified to properly
--              select to the beginning/end of the word.
--              t for local select, T for remote select. They give less control but 
--              mostly sufficient.
--              r for remote flash. It's useful because cursor position restores after
--              action (cannot achieve the same with treesitter search)
--


return {
	"folke/flash.nvim",
  keys = {
    { "s", mode = { "n", "x", "o" }, false},
    { "S", mode = { "n", "x", "o" }, false},
    { "r", mode = { "o", "x" }, false},
    { "R", mode = { "o", "x" }, false},
    { "f", mode = { "n" }, function() require("flash").jump() end, desc = "Flash" },
    { "F", mode = { "n" }, function() require("flash").jump({continue = true}) end, desc = "Flash Last Search" },
    { "f", mode = { "x", "o" }, function() require("flash").jump({ search = { forward = true, wrap = false, multi_window = false },}) end, desc = "Flash Forward" },
    { "F", mode = { "x", "o" }, function() require("flash").jump({ search = { forward = false, wrap = false, multi_window = false }, jump = { pos = "start" }}) end, desc = "Flash Backward" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" }, -- this shows up in visual mode as well, but doesn't work (still replace)
    { "t", mode = { "n" }, function() require("flash").treesitter(
      { jump = { pos = "end" }, label = { before = false, after = true }, }
    ) end, desc = "Flash Treesitter" },
    { "T", mode = { "n" }, function() require("flash").treesitter(
      { jump = { pos = "start" }, label = { before = true, after = false }, }
    ) end, desc = "Flash Treesitter" },
    { "t", mode = { "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "T", mode = { "x", "o" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  },
	opts = {
		modes = {
			char = {
				jump_labels = true,
        enabled = false
			},
      treesitter_search = {
        remote_op = { restore = true }, -- restore is not working somehow
      }
		},
    label = {
      rainbow = { enabled = true, shade = 2},
    },
    jump = {
      pos = "end", -- jump position
    },

	},
}
